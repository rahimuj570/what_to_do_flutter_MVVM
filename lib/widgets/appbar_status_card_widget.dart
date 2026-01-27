import 'package:flutter/material.dart';

class AppbarStatusCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final int quantity;
  const AppbarStatusCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(title),
          Text(
            quantity.toString(),
            style: TextTheme.of(
              context,
            ).headlineLarge!.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
