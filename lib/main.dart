import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_task_management/app/app.dart';
import 'package:mvvm_task_management/firebase_options.dart';
import 'package:mvvm_task_management/services/notification_servicee.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().initialize();

  runApp(const TodoApp());
}
