import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double dotRadius;
  final double spacing;

  const DottedLine({
    Key? key,
    required this.height,
    this.color = Colors.black,
    this.dotRadius = 3,
    this.spacing = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: DottedLinePainter(color: color, dotRadius: dotRadius, spacing: spacing),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotRadius;
  final double spacing;

  DottedLinePainter({required this.color, required this.dotRadius, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final double halfDotRadius = dotRadius / 2;

    for (double i = 0; i < size.width; i += spacing * 2) {
      canvas.drawCircle(Offset(i, size.height / 2), halfDotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Dotted Line with Circular Endings'),
      ),
      body: Center(
        child: DottedLine(
          height: 2,
          color: Colors.black,
          dotRadius: 3,
          spacing: 5,
        ),
      ),
    ),
  ));
}
