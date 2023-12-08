import 'package:bookihub/src/features/authentication/presentation/provider/auth_provider.dart';
import 'package:bookihub/src/features/reports/domain/entities/report_model.dart';
import 'package:bookihub/src/features/reports/presentation/provider/report_controller.dart';
import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:bookihub/src/shared/utils/date_time.formatting.dart';
import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:bookihub/src/shared/utils/show.snacbar.dart';
import 'package:provider/provider.dart';

import '../widgets/report_card.dart';

class AllReportView extends StatefulWidget {
  const AllReportView({super.key});

  @override
  State<AllReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<AllReportView> {
  Future<List<Report>>? reports;
  fetchReports() async {
    final id = context.read<AuthProvider>().user;
    final result = await context.read<ReportProvider>().fetchReport(id);

    result
        .fold((failure) => showCustomSnackBar(context, failure.message, orange),
            (success) {
      if (mounted) {
        setState(() {
          reports = Future.value(success);
        });
      }
    });
  }

  @override
  void initState() {
    fetchReports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Incident Report',
            style: Theme.of(context).textTheme.headlineMedium!),
        backgroundColor: bg,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<List<Report>>(
            future: reports,
            builder: (context, snapshot) {
              List<Map<String, String>> dates = [];

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                var reports = snapshot.data!;
                for (var report in reports) {
                  dates.add({'date': date.format(report.updatedAt)});
                }
                return ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final reportDate = dates[index];
                      final prevState = index > 0 ? dates[index - 1] : null;
                      final isDiff = prevState == null ||
                          reportDate['date'] != prevState['date'];
                      final report = reports[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 10,
                            bottom: report == reports.last ? vPadding : 0.0),
                        child: Column(
                          children: [
                            if (isDiff)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: vPadding),
                                child: Text(
                                  reportDate['date']!,
                                  style: const TextStyle(color: orange),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: !isDiff ? vPadding : 0.0),
                              child: ReportCard(
                                report: reports[index],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('You have no made report available.'));
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
//  Column(
//           children: [
//             SizedBox(
//               height: MediaQuery.sizeOf(context).height * .06,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ReportCard(
//                   title: "Emergency Service",
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(
//                       builder: (context) {
//                         return const EmergencyView();
//                       },
//                     ));
//                   },
//                 ),
//                 ReportCard(
//                   title: "Fleet Mgt",
//                   onTap: () {
//                     // Navigator.push(context, MaterialPageRoute(
//                     //   builder: (context) {
//                     //     return const FleetMgtReport();
//                     //   },
//                     // ));
//                   },
//                 )
//               ],
//             ),
//           ],
//         ),

// class ReportCard extends StatelessWidget {
//   const ReportCard({super.key, this.title, this.onTap});
//   final String? title;
//   final void Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: MediaQuery.sizeOf(context).height * .18,
//         width: MediaQuery.sizeOf(context).width * .37,
//         decoration:
//             BoxDecoration(borderRadius: BorderRadius.circular(5), color: white),
//         child: Center(
//             child: Text(
//           title!,
//           style:
//               Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 16),
//           maxLines: 2,
//           textAlign: TextAlign.center,
//         )),
//       ),
//     );
//   }
// }
