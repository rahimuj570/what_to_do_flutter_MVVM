import 'package:flutter/material.dart';
import 'package:mvvm_task_management/app/app_colors.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  bool isFailed = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: isFailed ? null : Colors.white),
      ),

      backgroundColor: isFailed ? Colors.red : AppColors.themeColor,
    ),
  );
}
