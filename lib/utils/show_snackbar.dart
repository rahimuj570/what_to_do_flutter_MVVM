import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  bool isFailed = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isFailed ? Colors.red : null,
    ),
  );
}
