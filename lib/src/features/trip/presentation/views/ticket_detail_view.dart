import 'package:bookihub/src/features/trip/presentation/widgets/text_in_column.dart';
import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:bookihub/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';

class TicketDetailView extends StatefulWidget {
  const TicketDetailView({super.key});

  @override
  State<TicketDetailView> createState() => _TicketDetailViewState();
}

class _TicketDetailViewState extends State<TicketDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomButton(onPressed: null, child: Text('Ticket Details')),
            Material(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0)
                    .copyWith(top: 40),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Where from',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: blue, fontSize: 18),
                              ),
                              const Dash(
                                length: 60,
                              ),
                              Image.asset('assets/icons/bus.png'),
                              const Dash(
                                length: 60,
                              ),
                              Text(
                                'Where to',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: blue, fontSize: 18),
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('time'), Text('time')],
                          )
                        ],
                      ),
                    ),
                    vSpace,
                    vSpace,
                    vSpace,
                    const Dash(
                      length: 350,
                    ),
                    vSpace,
                    vSpace,
                    vSpace,
                    const DetailTile(
                      label: 'Full Name',
                      label2: 'Passengers',
                      sub: 'Stephen Essoun',
                      sub2: '2 Adult,1 Child',
                    ),
                    const DetailTile(
                      label: 'Trip Number',
                      label2: 'Payment Method',
                      sub: 'SDF678',
                      sub2: 'MOMO',
                    ),
                    const DetailTile(
                      label: 'Date',
                      label2: 'Time',
                      sub: '9 Febuary 2024',
                      sub2: '10:23 AM',
                    ),
                    const DetailTile(
                      label: 'Amount',
                      label2: 'Status',
                      sub: 'GHC 89.20',
                      sub2: 'Successful',
                    ),
                  ],
                ),
              ),
            ),
            vSpace,
            vSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(white),
                      foregroundColor: MaterialStateProperty.all(black),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    child: const Text('Verify'),
                    onPressed: () {},
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DetailTile extends StatelessWidget {
  const DetailTile({
    super.key,
    required this.label,
    required this.sub,
    required this.label2,
    required this.sub2,
  });
  final String label;
  final String sub;
  final String label2;
  final String sub2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInColumn(
            label: label,
            labelStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(color: grey),
            sub: sub,
            subStyle: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: const Color(0xff294783)),
            align: CrossAxisAlignment.start,
          ),
          TextInColumn(
            label: label2,
            labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: grey,
                ),
            sub: sub2,
            subStyle: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: const Color(0xff294783)),
            align: CrossAxisAlignment.end,
          ),
        ],
      ),
    );
  }
}
