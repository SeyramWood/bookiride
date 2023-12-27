// ignore_for_file: unused_element

import 'dart:developer' as console;
import 'dart:math';

import 'package:bookihub/main.dart';
import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../trip/domain/entities/trip_model.dart';

class RouteMap extends StatefulWidget {
  const RouteMap({
    super.key,
    required this.trip,
    this.dimension = .78,
    this.dimension2 = .601,
  });
  final Trip trip;
  final num dimension;
  final num dimension2;

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final Completer<GoogleMapController?> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  Marker? sourcePosition, destinationPosition;
  LocationData? _currentPosition;
  LatLng curLocation = const LatLng(0.0, 0.0);
  StreamSubscription<LocationData>? locationSubscription;
  Set<Marker> markers = {};
  String waypoints = '';

  @override
  void initState() {
    getNavigation();
    addMarker();
    super.initState();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  void addMarker() {
    if (!mounted) return;
    if (mounted) {
      setState(() {
        markers.add(Marker(
          markerId: MarkerId('curLoc_${DateTime.now().millisecondsSinceEpoch}'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          position: curLocation,
        ));
        markers.add(Marker(
          markerId: MarkerId('source_${DateTime.now().millisecondsSinceEpoch}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          position: LatLng(
            widget.trip.terminal.from.latitude,
            widget.trip.terminal.from.longitude,
          ),
        ));
        if (widget.trip.route.stops.isNotEmpty) {
          for (var stop in widget.trip.route.stops) {
            markers.add(
              Marker(
                markerId: MarkerId('stop ${markers.length + 1}'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRose),
                position: LatLng(stop.latitude, stop.longitude),
              ),
            );
          }
        }

        markers.add(Marker(
          markerId:
              MarkerId('destination_${DateTime.now().millisecondsSinceEpoch}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: LatLng(widget.trip.terminal.to.latitude,
              widget.trip.terminal.to.longitude),
        ));
      });

      console.log(markers.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          zoomControlsEnabled: false,
          polylines: Set<Polyline>.of(polylines.values),
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.trip.terminal.from.latitude,
                widget.trip.terminal.from.longitude),
            zoom: 9.0,
          ),
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        if (widget.trip.status == 'started')
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  // borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.circle),
              child: Center(
                child: IconButton(
                  onPressed: () async {
                    for (var stop in widget.trip.route.stops) {
                      waypoints += '${stop.latitude},${stop.longitude}|';
                      console.log(
                          'Added waypoint: ${stop.latitude},${stop.longitude}');
                    }
                    if (waypoints.isNotEmpty) {
                      waypoints = waypoints.substring(0, waypoints.length - 1);
                    } // Remove the trailing '|'

                    await launchUrl(Uri.parse(
                      'google.navigation:q=${widget.trip.terminal.to.latitude},${widget.trip.terminal.to.longitude}',
                    ));
                    console.log(
                      'Navigation URL: google.navigation:q=${widget.trip.terminal.from.latitude},${widget.trip.terminal.from.longitude}&waypoints=$waypoints&daddr=${widget.trip.terminal.to.latitude},${widget.trip.terminal.to.longitude}',
                    );
                    console.log(
                        'Navigation URL: google.navigation:q=${widget.trip.terminal.from.latitude},${widget.trip.terminal.from.longitude}&waypoints=$waypoints&daddr=${widget.trip.terminal.to.latitude},${widget.trip.terminal.to.longitude}');
                  },
                  icon: const Icon(
                    Icons.navigation_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ]),
    );
  }

  getNavigation() async {
    if (!mounted) return;
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    final GoogleMapController? controller = await _controller.future;
    location.changeSettings(accuracy: LocationAccuracy.high);
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (_permissionGranted == PermissionStatus.granted) {
      if (!mounted) return;
      _currentPosition = await location.getLocation();
      curLocation =
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
      getDirections();

      if (widget.trip.status == 'started') {
        locationSubscription =
            location.onLocationChanged.listen((LocationData currentLocation) {
          if (!mounted) return;
          controller?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(curLocation.latitude, curLocation.longitude),
                  zoom: 8.0)));
          {
            showMarkerInfo() async {
              final GoogleMapController? controller = await _controller.future;
              if (sourcePosition != null) {
                controller?.showMarkerInfoWindow(
                    MarkerId(sourcePosition!.markerId.value));
              }
            }

            setState(() {
              curLocation =
                  LatLng(currentLocation.latitude!, currentLocation.longitude!);
              sourcePosition = Marker(
                markerId: MarkerId(
                    'sourcepos_${DateTime.now().millisecondsSinceEpoch}'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                position: LatLng(
                    currentLocation.latitude!, currentLocation.longitude!),
                infoWindow: InfoWindow(
                    title: double.parse((getDistance().toStringAsFixed(2)))
                        .toString()),
              );
              //add source marker to the markers
              markers.add(sourcePosition!);
            });
            getDirections();
          }
        });
      }
    }
  }

  Future<void> getDirections() async {
    List<LatLng> polylinecoordinates = [];
    List<dynamic> points = [];

    const maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          apiKey,
          PointLatLng(widget.trip.terminal.from.latitude,
              widget.trip.terminal.from.longitude),
          PointLatLng(widget.trip.terminal.to.latitude,
              widget.trip.terminal.to.longitude),
          travelMode: TravelMode.driving,
        );

        if (result.points.isNotEmpty) {
          for (var point in result.points) {
            polylinecoordinates.add(LatLng(point.latitude, point.longitude));
            points.add({"lat": point.latitude, "lng": point.longitude});
          }

          addPolyline(polylinecoordinates);
        } else {
          print("No valid route found");
          // Handle the case when no valid route is found
        }
        return;
      } catch (e) {
        // Log the error and retry after a delay
        print('Error: $e');
        await Future.delayed(Duration(seconds: retryCount * 2));
        retryCount++;
      }
    }

    // Handle the case when all retries fail
    print('Failed to get directions after $maxRetries attempts.');
  }

  addPolyline(List<LatLng> polylinecoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: orange, points: polylinecoordinates, width: 3);
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double getDistance() {
    return calculateDistance(
        widget.trip.terminal.from.latitude,
        widget.trip.terminal.from.longitude,
        widget.trip.terminal.to.latitude,
        widget.trip.terminal.to.longitude);
  }
}
