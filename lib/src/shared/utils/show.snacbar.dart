import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String content,Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 8,backgroundColor: color,
    showCloseIcon: true,
    content: Text(content),
  ));
}
