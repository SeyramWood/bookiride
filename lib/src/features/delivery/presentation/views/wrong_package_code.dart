import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:bookihub/src/shared/utils/exports.dart';

wrongPCode(BuildContext context) {
  showDialog(
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
                size: 50,
                color: orange,
              ),
            ),
            vSpace,
            vSpace,
            Text(
              'The package code is wrong\n\nDo not deliver!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
      
    ),
  );
}
