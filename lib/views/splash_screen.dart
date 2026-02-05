import 'package:flutter/material.dart';
import 'package:mvvm_task_management/app/app_colors.dart';
import 'package:mvvm_task_management/views/home_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String name = 'splash_screen';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void geToHome() async {
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, HomeScreen.name);
    }

    geToHome();
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: AlignmentGeometry.center,
            child: Image.asset('assets/icon/icon.png', width: 150),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  backgroundColor: AppColors.themeColor,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(child: Text('version 1.0')),
          ),
        ],
      ),
    );
  }
}
