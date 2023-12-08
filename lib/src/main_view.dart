import 'package:bookihub/src/features/reports/presentation/views/accident_report.dart';

import 'shared/utils/exports.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  bool isSelected = false;

  onTap(index) {
    setState(() {
      currentIndex = index;
      isSelected = true;
    });
  }

  List<Widget> pages = [
    const TripsView(),
    const DeliveryView(),
    const ReportView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: white,
          elevation: 0,
          selectedItemColor: blue,
          unselectedItemColor: grey,
          onTap: onTap,
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(
                  CustomeImages.trips,
                )),
                label: "Trips"),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(
                  CustomeImages.delivery,
                )),
                label: "Delivery"),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(
                  CustomeImages.report,
                )),
                label: "Report"),
          ]),
    );
  }
}
