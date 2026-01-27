import 'package:flutter/material.dart';
import 'package:mvvm_task_management/app/app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    colorSchemeSeed: AppColors.themeColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.themeColor,
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
  );
  static ThemeData get dark => ThemeData(brightness: Brightness.dark);
}
