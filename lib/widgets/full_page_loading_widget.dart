import 'package:flutter/material.dart';
import 'package:mvvm_task_management/app/app_colors.dart';

class FullPageLoadingWidget extends StatelessWidget {
  const FullPageLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            backgroundColor: AppColors.themeColor,
          ),
        ),
      ),
    );
  }
}
