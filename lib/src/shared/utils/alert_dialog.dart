import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:flutter/material.dart';

showCustomDialog(
    BuildContext context, Widget content, void Function()? onPressed) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: hPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: content),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('later'),
                    ),
                    TextButton(
                      onPressed: onPressed,
                      child: const Text('continue'),
                    ),
                  ],
                )
              ],
            ),
          )),
    ),
  );
}
