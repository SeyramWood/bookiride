import 'package:bookihub/src/shared/utils/exports.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.child,
      this.bgColor = blue,
      required this.onPressed});
  final Widget child;
  final Color? bgColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .07,
      width: MediaQuery.sizeOf(context).width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(bgColor)),
        child: child,
      ),
    );
  }
}
