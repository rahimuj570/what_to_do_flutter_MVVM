import 'package:flutter/material.dart';
import 'package:mvvm_task_management/app/app.dart';
import 'package:mvvm_task_management/services/notification_servicee.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().initialize();
  runApp(const TodoApp());
}
