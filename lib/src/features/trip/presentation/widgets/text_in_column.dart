import '../../../../shared/utils/exports.dart';

class TextInColumn extends StatelessWidget {
  const TextInColumn({
    super.key,
    required this.label,
    required this.sub,
    this.labelStyle,
    this.subStyle,
    this.align,
  });

  final String label;
  final String sub;
  final TextStyle? labelStyle;
  final TextStyle? subStyle;
  final CrossAxisAlignment? align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align ?? CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: labelStyle,
        ),
        Text(
          sub,
          style: subStyle ??
              Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: orange,
                  ),
        ),
      ],
    );
  }
}
