import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:flutter_dash/flutter_dash.dart';

class CustomDottedLine extends StatelessWidget {
  final Color color;
  final double dotRadius;
  final double spacing;

  const CustomDottedLine({
    super.key,
    this.color = Colors.black,
    this.dotRadius = 1.5,
    this.spacing = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Dot(color: color, radius: dotRadius * 1.5),
        // SizedBox(width: spacing),
        Dash(
          length: MediaQuery.of(context).size.width * .06,
          dashColor: grey,
          dashThickness: 3,
          dashLength: 2,
        ),
        // SizedBox(width: spacing),
        _Dot(color: color, radius: dotRadius * 1.5),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double radius;

  const _Dot({
    required this.color,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: grey,
      ),
    );
  }
}
