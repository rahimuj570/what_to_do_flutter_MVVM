import 'package:flutter/material.dart';
import 'package:mvvm_task_management/app/app_colors.dart';
import 'package:mvvm_task_management/view_models/todo_provider.dart';
import 'package:provider/provider.dart';

class AppbarStatusCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final int quantity;
  final int status;
  const AppbarStatusCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.quantity,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, value, child) => Card(
        shape: value.currentStatusTab == status
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(width: 2),
              )
            : null,

        child: InkWell(
          splashColor: const Color.fromARGB(255, 187, 214, 255),
          highlightColor: const Color.fromARGB(255, 187, 214, 255),
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            value.changeCurrentStatusTab(status);
          },
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
        ),
      ),
    );
  }
}
