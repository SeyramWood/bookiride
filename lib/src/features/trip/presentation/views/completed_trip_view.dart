import 'dart:async';

import 'package:bookihub/src/features/authentication/presentation/provider/auth_provider.dart';
import 'package:bookihub/src/features/trip/domain/entities/trip_model.dart';
import 'package:bookihub/src/features/trip/domain/entities/trip_type.dart';
import 'package:bookihub/src/features/trip/presentation/provider/trip_provider.dart';
import 'package:bookihub/src/features/trip/presentation/widgets/trip_card.dart';
import 'package:bookihub/src/shared/constant/colors.dart';
import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:bookihub/src/shared/utils/date_time.formatting.dart';
import 'package:bookihub/src/shared/utils/show.snacbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedTripView extends StatefulWidget {
  const CompletedTripView({super.key});

  @override
  State<CompletedTripView> createState() => _CompletedTripViewState();
}

class _CompletedTripViewState extends State<CompletedTripView> {
  late List<Trip> trip;
  final StreamController<List<Trip>> _streamController = StreamController();
// ignore: unused_field
  late Timer _timer;
  fetchTrips() async {
    if (mounted) {
      final result = await context.read<TripProvider>().fetchTrips(
            context.read<AuthProvider>().user,
            TripType(
              today: false,
              scheduled: false,
              completed: true,
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

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
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

  List<Map<String, String>> dates = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Trip>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          var trips = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            //check and add dates for sorting
            for (var trip in trips!) {
              dates.add({'date': date.format(trip.arrivalDate)});
            }

            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final cn = dates[index];
                final prevState = index > 0 ? dates[index - 1] : null;
                final isDiff =
                    prevState == null || cn['date'] != prevState['date'];
                var trip = trips[index];

                return Column(
                  children: [
                    if (isDiff)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: vPadding),
                        child: Text(
                          cn['date']!,
                          style: const TextStyle(color: orange),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(top: !isDiff ? vPadding : 0.0),
                      child: TripCard(
                        location: trip.route.from,
                        lDescription: trip.terminal.from.name,
                        destination: trip.route.to,
                        dDescription: trip.terminal.to.name,
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
