import 'dart:developer';

import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:bookihub/src/shared/widgets/custom_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
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
  bool _isMultipleStop = false;
  MapBoxNavigationViewController? _controller;
  bool routeBuilt = false;
  bool _isNavigating = false;
  late MapBoxOptions _navigationOption;

  @override
  void initState() {
    super.initState();
    initialize();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        var wayPoints = <WayPoint>[];
        wayPoints.add(WayPoint(
            name: "Source",
            latitude: widget.trip.route.fromLatitude,
            longitude: widget.trip.route.fromLongitude,
            isSilent: false));
        wayPoints.add(WayPoint(
            name: "Your destination",
            latitude: widget.trip.route.toLatitude,
            longitude: widget.trip.route.toLongitude,
            isSilent: false));
  //adding stop if there is.
        if (widget.trip.route.stops.isNotEmpty) {
          for (var stop in widget.trip.route.stops) {
            wayPoints.add(
              WayPoint(
                name: 'stop ${wayPoints.length + 1}',
                latitude: stop.latitude,
                longitude: stop.longitude,
              ),
            );
          }
        }
        log(wayPoints.toString());

        _isMultipleStop = wayPoints.length > 2;
        _controller?.buildRoute(
          wayPoints: wayPoints,
          options: _navigationOption,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.simulateRoute = false;
    _navigationOption.language = "en";
    _navigationOption.enableRefresh = true;

    MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);

    try {
      await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      // Handle the exception if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.grey,
              child: MapBoxNavigationView(
                  options: _navigationOption,
                  onRouteEvent: _onRouteEvent,
                  onCreated: (MapBoxNavigationViewController controller) async {
                    _controller = controller;
                    controller.initialize();
                  }),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * widget.dimension2,
              left: MediaQuery.of(context).size.width * widget.dimension,
              child: SizedBox(
                width: 75,
                height: 55,
                child: CustomButton(
                  onPressed: _isNavigating
                      ? null
                      : () {
                          setState(
                            () {
                              if (_isNavigating) {
                                _controller?.finishNavigation();
                              } else {
                                _controller?.startNavigation();
                              }
                            },
                          );
                        },
                  child: const Icon(Icons.navigation),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onRouteEvent(RouteEvent e) async {
    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          setState(() {
            _isNavigating = true;
            routeBuilt = true;
          });
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        setState(() {
          _isNavigating = false;
        });
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
  }
}