import 'package:flutter/material.dart';
import 'package:mvvm_task_management/app/app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: AppColors.themeColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.themeColor,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(),
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
      ),
    ),
  );
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(backgroundColor: AppColors.themeColor),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(),
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
