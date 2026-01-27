import 'package:flutter/material.dart';
import 'package:mvvm_task_management/views/add_todo_screen.dart';
import 'package:mvvm_task_management/views/home_screen.dart';

class AppRoute {
  static Route<dynamic>? appRoutes(RouteSettings settings) {
    Widget widget = SizedBox();
    if (settings.name == HomeScreen.name) {
      widget = HomeScreen();
    } else if (settings.name == AddTodoScreen.name) {
      widget = AddTodoScreen();
    }
    return MaterialPageRoute(builder: (context) => widget);
  }
}
