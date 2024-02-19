import 'package:bookihub/src/features/authentication/presentation/view/login_view.dart';
import 'package:bookihub/src/features/authentication/presentation/view/update_password_form.dart';
import 'package:bookihub/src/features/trip/presentation/views/completed_trip_view.dart';
import 'package:bookihub/src/features/trip/presentation/views/scheduled_trip_view.dart';
import 'package:bookihub/src/features/trip/presentation/views/todays_trip_view.dart';
import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:bookihub/src/shared/utils/alert_dialog.dart';
import 'package:bookihub/src/shared/utils/interceptor.dart';
import 'package:bookihub/src/shared/utils/show.snacbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/utils/exports.dart';

class TripsView extends StatefulWidget {
  const TripsView({super.key});

  @override
  State<TripsView> createState() => _TripsViewState();
}

int isSelected = 0;
int selectedTab = 0;

class _TripsViewState extends State<TripsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: hPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 4,
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //update password
                                GestureDetector(
                                  onTap: () {
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PasswordUpdateForm(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Update password"),
                                      Icon(Icons.update)
                                    ],
                                  ),
                                ),
                                vSpace,
                                vSpace,
                                vSpace,
                                //logout button
                                GestureDetector(
                                  onTap: () async {
                                    storage.deleteAll();
                                    var pref =
                                        await SharedPreferences.getInstance();
                                    pref.clear();

                                    if (mounted) {
                                      showCustomSnackBar(context,
                                          'successfully logged out', green);
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginView(),
                                          ),
                                          (route) => false);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Logout",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: orange),
                                      ),
                                      Icon(
                                        Icons.logout,
                                        color: orange,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      // showCustomDialog(
                      //     context, const Text('By continuing will log you out'),
                      //     () async {
                      //   storage.deleteAll();
                      //   var pref = await SharedPreferences.getInstance();
                      //   pref.clear();
                      //
                      //   if (mounted) {
                      //     showCustomSnackBar(
                      //         context, 'successfully logged out', green);
                      //     Navigator.of(context).pushAndRemoveUntil(
                      //         MaterialPageRoute(
                      //           builder: (context) => const LoginView(),
                      //         ),
                      //         (route) => false);
                      //   }
                      // });
                    },
                    icon: const Icon(
                      Icons.power_settings_new_rounded,
                      color: orange,
                    ),
                  ),
                ],
              ),
              // vSpace,
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.045,
                child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(
                          width: MediaQuery.sizeOf(context).width * .045,
                        ),
                    shrinkWrap: true,
                    itemCount: tabs.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return TripsTab(
                        title: tabs[index]['title'],
                        index: index,
                        isSelectedIndex: selectedTab,
                        onTap: () {
                          setState(() {
                            selectedTab = index;
                          });
                        },
                      );
                    }),
              ),
              vSpace,
              Expanded(
                // height: MediaQuery.sizeOf(context).height * 0.7,
                child: (selectedTab == 0)
                    ? const TodayTripsView()
                    : (selectedTab == 1)
                        ? const ScheduledTripView()
                        : const CompletedTripView(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
