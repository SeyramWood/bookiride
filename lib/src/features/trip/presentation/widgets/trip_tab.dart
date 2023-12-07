import 'package:bookihub/src/shared/constant/dimensions.dart';

import '../../../../shared/utils/exports.dart';

class TripsTab extends StatelessWidget {
  const TripsTab(
      {super.key, this.index, this.isSelectedIndex, this.onTap, this.title});
  final void Function()? onTap;
  final int? isSelectedIndex;
  final int? index;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width / 3.9,
        decoration: BoxDecoration(
            color: isSelectedIndex == index ? blue : bg,
            borderRadius: borderRadius,
            border: Border.all(color: isSelectedIndex == index ? blue : grey)),
        child: Center(
            child: Text(
          title!,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: isSelectedIndex == index ? white : black),
        )),
      ),
    );
  }
}

List<Map<String, String>> tabs = [
  {"title": "Today"},
  {"title": "Scheduled"},
  {"title": "Completed"}
];
