import 'package:flutter/material.dart';
// import 'package:joojo_delivery/Utils/common_styles.dart';

class OrderButton extends StatelessWidget {
  const OrderButton(
      {super.key,
      this.title,
      this.borderColor,
      this.textColor,
      this.onTap,
      this.width});

  final String? title;
  final Color? borderColor;
  final Color? textColor;
  final void Function()? onTap;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: TextButton(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: borderColor!))),
            onPressed: onTap,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                title!,
                // style: mediumTextStyle.copyWith(
                //     color: textColor, fontWeight: FontWeight.w600),
              ),
            )),
      ),
    );
  }
}
