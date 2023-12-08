import 'package:bookihub/src/features/authentication/presentation/provider/auth_provider.dart';
import 'package:bookihub/src/features/trip/domain/entities/trip_model.dart';
import 'package:bookihub/src/features/trip/domain/entities/trip_type.dart';
import 'package:bookihub/src/features/trip/presentation/provider/trip_provider.dart';
import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:bookihub/src/shared/utils/show.snacbar.dart';
import 'package:provider/provider.dart';

import '../../../../shared/utils/date_time.formatting.dart';
import '../../../../shared/utils/exports.dart';

class TodayTripsView extends StatefulWidget {
  const TodayTripsView({super.key});

  @override
  State<TodayTripsView> createState() => _TodayTripsViewState();
}

class _TodayTripsViewState extends State<TodayTripsView> {
  late List<Trip> trip;
  final StreamController<List<Trip>> _streamController = StreamController();
// ignore: unused_field
  late Timer _timer;
  fetchTrips() async {
    if (mounted) {
      final result = await context.read<TripProvider>().fetchTrips(
            context.read<AuthProvider>().user,
            TripType(
              today: true,
              scheduled: false,
              completed: false,
            ),
          );

      result.fold(
          (failure) => showCustomSnackBar(context, failure.message, orange),
          (success) {
        
        if (mounted) {
          _streamController.sink.add(success);
          setState(() {
            trip = success;
          });
        }
      });
    }
  }

  @override
  void initState() {
    fetchTrips();

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      fetchTrips();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamController.close(); // Close the stream controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Trip>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          var todayTrips = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                      height: MediaQuery.sizeOf(context).height * .02,
                    ),
                shrinkWrap: true,
                itemCount: todayTrips!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var trip = todayTrips[index];

                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: trip == todayTrips.last ? vPadding : 0.0),
                    child: TripCard(
                      location: trip.route.from,
                      lDescription: trip.terminal.from.name ,
                      destination: trip.route.to,
                      dDescription: trip.terminal.to.name ,
                      startTime: time.format(trip.departureDate),
                      endTime: time.format(trip.arrivalDate),
                    ),
                  );
                });
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You have no trip available.'));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
