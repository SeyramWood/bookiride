import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:bookihub/src/shared/utils/exports.dart';

successDelivery(BuildContext context) {
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
              child: Image.asset(
                'assets/images/i2.png',
                fit: BoxFit.cover,
              ),
            ),
            vSpace,
            vSpace,
            Text(
              'Package delivered\nsuccessfully',
              textAlign: TextAlign.center,
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
            child: const Text('Close'),
          ),
        )
      ],
    ),
  );
}
