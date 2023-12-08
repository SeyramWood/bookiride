// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bookihub/src/features/map/presentation/views/map_view.dart';
import 'package:bookihub/src/shared/utils/exports.dart';

import '../../domain/entities/trip_model.dart';

class TripTrackingView extends StatefulWidget {
  const TripTrackingView({
    Key? key,
    required this.trip,
  }) : super(key: key);
  final Trip trip;

  @override
  State<TripTrackingView> createState() => _TripTrackingViewState();
}

class _TripTrackingViewState extends State<TripTrackingView> {
  injectedMap() {
    return RouteMap(dimension2: .8, trip: widget.trip);
  }

  @override
  void initState() {
    super.initState();
    injectedMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Trip Route",
            style: Theme.of(context).textTheme.headlineMedium!),
        backgroundColor: bg,
      ),
      body: injectedMap(),
    );
  }
}
