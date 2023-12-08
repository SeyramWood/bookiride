import 'package:bookihub/src/shared/utils/exports.dart';

class CircularPercentageIndicator extends StatelessWidget {
  final double percentage; 
  

  const CircularPercentageIndicator({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator.adaptive(
              backgroundColor: grey,
              value: percentage, // Progress value between 0.0 and 1.0
              strokeWidth: 7, // Adjust the thickness of the progress indicator
            ),
            Text(
              '${(percentage * 100).toStringAsFixed(0)}%',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ), // Add some spacing
      ],
    );
  }
}
