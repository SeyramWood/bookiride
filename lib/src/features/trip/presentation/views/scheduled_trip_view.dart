import 'package:bookihub/main.dart';
import 'package:bookihub/src/features/authentication/presentation/provider/auth_provider.dart';
import 'package:bookihub/src/features/trip/domain/entities/trip_model.dart';
import 'package:bookihub/src/features/trip/domain/entities/trip_type.dart';
import 'package:bookihub/src/features/trip/presentation/provider/trip_provider.dart';
import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:bookihub/src/shared/utils/date_time.formatting.dart';
import 'package:bookihub/src/shared/utils/show.snacbar.dart';
import 'package:provider/provider.dart';

import '../../../../shared/utils/exports.dart';

class ScheduledTripView extends StatefulWidget {
  const ScheduledTripView({super.key});

  @override
  State<ScheduledTripView> createState() => _ScheduledTripViewState();
}

class _ScheduledTripViewState extends State<ScheduledTripView> {
  // Future<List<Trip>>? trips;
  late List<Trip> trips;
  final StreamController<List<Trip>> _streamController = StreamController();
// ignore: unused_field
  late Timer _timer;
  fetchTrips() async {
    if (mounted) {
      final result = await context.read<TripProvider>().fetchTrips(
            context.read<AuthProvider>().user,
            TripType(
              today: false,
              scheduled: true,
              completed: false,
            ),
          );
      result.fold(
          (failure) => showCustomSnackBar(context, failure.message, orange),
          (success) {
        if (mounted) {
          _streamController.sink.add(success);
          setState(() {
            trips = success;
          });
        }
      });
    }
  }

  @override
  void initState() {
    fetchTrips();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
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

  final List<Map<String, String>> dates = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Trip>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            //check and add dates for sorting
            for (var trip in trips) {
              dates.add({'date': date.format(trip.departureDate)});
            }

            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                //injecting a data to a trip for use in reporting incidents.

                final cn = dates[index];
                final prevState = index > 0 ? dates[index - 1] : null;
                final isDiff =
                    prevState == null || cn['date'] != prevState['date'];
                var trip = trips[index];
                if (!locator.isRegistered<Trip>()) {
                  locator.registerLazySingleton<Trip>(() => trip);
                }
                return Column(
                  children: [
                    if (isDiff)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: vPadding),
                        child: Text(cn['date']!),
                      ),
                    Padding(
                      padding: EdgeInsets.only(top: !isDiff ? vPadding : 0.0),
                      child: TripCard(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TripDetails(trip: trip),
                            ),
                          );
                        },
                        location: trip.route.from,
                        lDescription: trip.terminal.from.name  ,
                        destination: trip.route.to,
                        dDescription: trip.terminal.to.name ,
                        startTime: time.format(trip.departureDate),
                        endTime: time.format(trip.arrivalDate),
                      ),
                    )
                  ],
                );
              },
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You have no trip available.'));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
