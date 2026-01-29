import 'package:flutter/material.dart';
import 'package:mvvm_task_management/app/app_colors.dart';

class BtnLoading extends StatelessWidget {
  const BtnLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(backgroundColor: AppColors.themeColor);
  }
}
