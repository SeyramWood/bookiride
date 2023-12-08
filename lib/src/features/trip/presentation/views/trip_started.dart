// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bookihub/src/shared/utils/button_extension.dart';
import 'package:bookihub/src/shared/utils/show.snacbar.dart';
import 'package:provider/provider.dart';

import 'package:bookihub/src/features/map/presentation/views/map_view.dart';
import 'package:bookihub/src/features/trip/domain/entities/trip_model.dart';
import 'package:bookihub/src/features/trip/presentation/provider/trip_provider.dart';
import 'package:bookihub/src/features/trip/presentation/views/trip_tracker.dart';
import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:bookihub/src/shared/widgets/custom_button.dart';

import '../../../../shared/utils/alert_dialog.dart';
import '../../../reports/presentation/views/fleet_mgt.dart';

class TripStartedView extends StatefulWidget {
  const TripStartedView({
    Key? key,
    required this.trip,
  }) : super(key: key);
  final Trip trip;

  @override
  State<TripStartedView> createState() => _TripStartedViewState();
}

class _TripStartedViewState extends State<TripStartedView> {
  injectedMap() {
    return RouteMap(dimension: .68, trip: widget.trip);
  }

  @override
  Widget build(BuildContext context) {
    var time = context.read<TripProvider>().tripStartedTime ?? DateTime.now();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Trip Details",
            style: Theme.of(context).textTheme.headlineMedium!),
        backgroundColor: bg,
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                showDragHandle: true,
                isScrollControlled: true,
                isDismissible: false,
                useSafeArea: true,
                context: context,
                builder: (context) => SizedBox(
                    height: MediaQuery.sizeOf(context).height * .9,
                    child: const FleetMgtReport()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0).copyWith(right: 15),
              child: const CircleAvatar(
                  backgroundColor: white,
                  radius: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.report_problem_outlined),
                      Text(
                        'Report',
                        style: TextStyle(fontSize: 8),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .7,
              width: MediaQuery.sizeOf(context).width * .9,
              child: Stack(
                children: [
                  Center(child: injectedMap()),
                  Positioned(
                      top: MediaQuery.sizeOf(context).height * .5,
                      left: MediaQuery.sizeOf(context).width * .7,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return TripTrackingView(
                                  trip: widget.trip,
                                );
                              },
                            ));
                          },
                          child: const CircleAvatar(
                            backgroundColor: white,
                            child: Icon(Icons.expand),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * .02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Trip Started",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * .01),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .58,
                      child: Material(
                        shape: OutlineInputBorder(
                            borderSide: const BorderSide(color: blue),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            '${time.hour} hour: ${time.minute} mins: ${time.second} secs',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w600, color: blue),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .02,
                    ),
                    SizedBox(
                      height: 40,
                      width: MediaQuery.sizeOf(context).width * .28,
                      child: CustomButton(
                        bgColor: orange,
                        onPressed: () {
                          showCustomDialog(context,
                              const Text('Do you want to end this trip?'),
                              () async {
                            Navigator.of(context).pop();
                            await context
                                .read<TripProvider>()
                                .updateTripStatus('${widget.trip.id}', 'ended')
                                .then(
                              (result) {
                                result.fold((l) {
                                  showCustomSnackBar(
                                      context, l.message, orange);
                                }, (r) {
                                  context.read<TripProvider>().startedDate =
                                      DateTime.now();
                                  showCustomSnackBar(
                                    context,
                                    'Trip successfully ended',
                                    green,
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const MainPage();
                                      },
                                    ),
                                    (route) => false,
                                  );
                                });
                              },
                            );
                          });
                        },
                        child: const Text("End Trip"),
                      ).loading(context.watch<TripProvider>().isLoading),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
