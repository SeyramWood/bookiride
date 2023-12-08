import 'package:bookihub/src/features/trip/presentation/provider/trip_provider.dart';
import 'package:bookihub/src/features/trip/presentation/views/trip_started.dart';
import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:bookihub/src/shared/utils/alert_dialog.dart';
import 'package:bookihub/src/shared/utils/button_extension.dart';
import 'package:bookihub/src/shared/utils/divider.dart';
import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:bookihub/src/features/map/presentation/views/map_view.dart';
import 'package:bookihub/src/shared/utils/show.snacbar.dart';
import 'package:bookihub/src/shared/widgets/custom_button.dart';
import 'package:bookihub/src/shared/widgets/percentage_indicator.dart';
import 'package:bookihub/src/features/trip/presentation/widgets/trip_inspect_row.dart';
import 'package:bookihub/src/features/trip/domain/entities/trip_model.dart';
import 'package:provider/provider.dart';
import 'package:bookihub/src/shared/constant/model.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({super.key, required this.trip});
  final Trip trip;

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  bool value1 = false;
  bool value2 = false;
  bool value3 = false;
  bool value4 = false;
  bool value5 = false;
  bool value6 = false;

  double checkPercentage = 0.0;
  injectedMap() {
    return RouteMap(trip: widget.trip);
  }

  @override
  void initState() {
    injectedMap();
    isInspected();
    super.initState();
  }

  isInspected() {
    if (widget.trip.inspectionStatus.brakeAndSteering == true) {
      checkPercentage = 0.9999999999999999;
      value1 = true;
      value2 = true;
      value3 = true;
      value4 = true;
      value5 = true;
      value6 = true;
    }
  }

  bool isEnabled = false;
  @override
  Widget build(BuildContext context) {
    bool isChecked = checkPercentage == 0.9999999999999999;
    var trip = widget.trip;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Trip Details',
            style: Theme.of(context).textTheme.headlineMedium,
          )),
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: hPadding, vertical: vPadding),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    borderRadius: borderRadius,
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * .7,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                margin: const EdgeInsets.all(10),
                                width: MediaQuery.sizeOf(context).width * .13,
                                child: Image.asset('assets/images/fleet.png')),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Trip ID: ${trip.id}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(color: titleColor),
                                ),
                                Text(
                                  'Bus Number: ${trip.vehicle.registrationNumber}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(color: titleColor),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showModalBottomSheet(
                      showDragHandle: true,
                      isScrollControlled: true,
                      useSafeArea: true,
                      isDismissible: false,
                      context: context,
                      builder: (context) => SizedBox(
                          height: MediaQuery.sizeOf(context).height * .7,
                          child: mounted ? injectedMap() : null),
                    ),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * .15,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: orange,
                      ),
                      child: Center(
                          child: Text(
                        'View\nRoute',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: white),
                      )),
                    ),
                  )
                ],
              ),
            ),
            vSpace,
            Divider(color: orange.withOpacity(.4)),
            vSpace,
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .1,
              child: Material(
                borderRadius: borderRadius,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentageIndicator(percentage: checkPercentage),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Pre-Trip Inspection',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ),
            vSpace,
            vSpace,
            //inspection card
            Material(
              borderRadius: borderRadius,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: hPadding),
                child: Column(children: [
                  vSpace,
                  TripInspectRow(
                    label: 'Exterior Inspection',
                    onChanged: () async {
                      setState(() {
                        value1 = !value1;
                        value1
                            ? checkPercentage = (checkPercentage + 1 / 6)
                            : checkPercentage = (checkPercentage - 1 / 6);
                      });
                    },
                    value: value1,
                  ),
                  divider,
                  TripInspectRow(
                    label: 'Interior Inspection',
                    onChanged: () async {
                      setState(() {
                        value2 = !value2;
                        value2
                            ? checkPercentage = (checkPercentage + 1 / 6)
                            : checkPercentage = (checkPercentage - 1 / 6);
                      });
                    },
                    value: value2,
                  ),
                  divider,
                  TripInspectRow(
                    label: 'Engine Compartment',
                    onChanged: () async {
                      setState(() {
                        value3 = !value3;
                        value3
                            ? checkPercentage = (checkPercentage + 1 / 6)
                            : checkPercentage = (checkPercentage - 1 / 6);
                      });
                    },
                    value: value3,
                  ),
                  divider,
                  TripInspectRow(
                    label: 'Brakes and Steering',
                    onChanged: () async {
                      setState(() {
                        value4 = !value4;
                        value4
                            ? checkPercentage = (checkPercentage + 1 / 6)
                            : checkPercentage = (checkPercentage - 1 / 6);
                      });
                    },
                    value: value4,
                  ),
                  divider,
                  TripInspectRow(
                    label: 'Emergency Equipment',
                    onChanged: () async {
                      setState(() {
                        value5 = !value5;
                        value5
                            ? checkPercentage = (checkPercentage + 1 / 6)
                            : checkPercentage = (checkPercentage - 1 / 6);
                      });
                    },
                    value: value5,
                  ),
                  divider,
                  TripInspectRow(
                    label: 'Fuel and Fluids',
                    onChanged: () async {
                      setState(() {
                        value6 = !value6;
                        value6
                            ? checkPercentage = (checkPercentage + 1 / 6)
                            : checkPercentage = (checkPercentage - 1 / 6);
                      });
                    },
                    value: value6,
                  ),
                  vSpace,
                ]),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 35,
              child: CustomButton(
                bgColor: (!isChecked &&
                        trip.inspectionStatus.brakeAndSteering == false
                    ? grey
                    : trip.inspectionStatus.brakeAndSteering == true ||
                            isEnabled
                        ? grey
                        : null),
                onPressed: () async {
                  if (isChecked &&
                      trip.inspectionStatus.brakeAndSteering == false) {
                    await context
                        .read<TripProvider>()
                        .updateInspectionStatus(
                            '${trip.id}',
                            InspectionStatus(
                              brakeAndSteering: true,
                              emergencyEquipment: true,
                              engineCompartment: true,
                              exterior: true,
                              fuelAndFluid: true,
                              interior: true,
                            ))
                        .then(
                      (value) {
                        value.fold(
                          (l) => showCustomSnackBar(context, l.message, orange),
                          (r) {
                            setState(() {
                              isEnabled = true;
                            });
                            showCustomSnackBar(context, r, green);
                          },
                        );
                      },
                    );
                  }
                },
                child: Text(
                    trip.inspectionStatus.brakeAndSteering == true || isEnabled
                        ? 'Inspections\'re already sent '
                        : 'Submit Inspections'),
              ).loading(context.watch<TripProvider>().isUpdating),
            ),
            const Spacer(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .07,
              child: CustomButton(
                onPressed: trip.status == 'started'
                    ? () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return TripStartedView(
                              trip: trip,
                            );
                          },
                        ))
                    : () {
                        if (isEnabled ||
                            trip.inspectionStatus.brakeAndSteering == true) {
                          showCustomDialog(context,
                              const Text('Do you want to start this trip?'),
                              () async {
                            Navigator.of(context).pop();

                            await context
                                .read<TripProvider>()
                                .updateTripStatus('${trip.id}', 'started')
                                .then(
                              (result) {
                                result.fold((l) {
                                  showCustomSnackBar(
                                      context, l.message, orange);
                                }, (r) {
                                  context.read<TripProvider>().startedDate =
                                      DateTime.now();
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return TripStartedView(
                                        trip: trip,
                                      );
                                    },
                                  ));
                                });
                              },
                            );
                          });
                        }
                      },
                bgColor:
                    isEnabled || trip.inspectionStatus.brakeAndSteering != false
                        ? blue
                        : grey,
                child: Text(
                    trip.status == 'started' ? 'Enter trip' : 'Start Trip'),
              ).loading(context.watch<TripProvider>().isLoading),
            )
          ]),
        );
      }),
    );
  }
}
