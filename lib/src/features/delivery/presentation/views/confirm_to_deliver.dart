import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:bookihub/src/shared/utils/exports.dart';

confirmToDeliver(BuildContext context,{required void Function()onPressed}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: vPadding + 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .1,
              child: const ImageIcon(
                AssetImage('assets/images/i1.png'),
                color: blue,
                size: 50,
              ),
            ),
            vSpace,
            Text(
              'The package code is correct',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: blue,
                  ),
            ),
            vSpace,
            vSpace,
            Text(
              'Do you want to deliver the package?',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(white),
              side: MaterialStateProperty.all(
                const BorderSide(color: blue),
              ),
            ),
            child: const Text(
              'Close',
              style: TextStyle(color: black),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: onPressed,
            child: const Text('Yes'),
          ),
        )
      ],
    ),
  );
}
