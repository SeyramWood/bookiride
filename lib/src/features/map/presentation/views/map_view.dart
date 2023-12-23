// ignore_for_file: unused_field

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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;

  MapBoxNavigationViewController? _controller;
  bool routeBuilt = false;
  bool _isNavigating = false;
  late MapBoxOptions _navigationOption;
  String? _platformVersion;
  String? _instruction;

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
            latitude: widget.trip.terminal.from.latitude,
            longitude: widget.trip.terminal.from.longitude,
            isSilent: false));

        // adding stop if there is.
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
        wayPoints.add(WayPoint(
            name: "Your destination",
            latitude: widget.trip.terminal.to.latitude,
            longitude: widget.trip.terminal.to.longitude,
            isSilent: false));
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
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.simulateRoute = true;
    _navigationOption.language = "en";
    //_navigationOption.initialLatitude = 36.1175275;
    //_navigationOption.initialLongitude = -115.1839524;
    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);

    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.grey,
              child: MapBoxNavigationView(
                  options: _navigationOption,
                  onRouteEvent: _onEmbeddedRouteEvent,
                  onCreated: (MapBoxNavigationViewController controller) async {
                    _controller = controller;
                    controller.initialize();
                  }),
            ),
            if(routeBuilt)
            Positioned(
              top: MediaQuery.of(context).size.height * widget.dimension2,
              left: MediaQuery.of(context).size.width * widget.dimension,
              child: SizedBox(
                width: 75,
                height: 55,
                child: CustomButton(
                  onPressed: routeBuilt && !_isNavigating
                      ? () {
                          _controller?.startNavigation();
                        }
                      : null,
                  child: const Icon(Icons.navigation),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
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
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        scaffoldKey.currentState?.setState(() {
          routeBuilt = false;
          _isNavigating = false;
        });

        break;
      default:
        break;
    }
    setState(() {});
  }
}
