import 'package:flutter/material.dart';
import 'package:mvvm_task_management/app/app_route.dart';
import 'package:mvvm_task_management/app/app_theme.dart';
import 'package:mvvm_task_management/view_models/theme_provider.dart';
import 'package:mvvm_task_management/view_models/todo_provider.dart';
import 'package:mvvm_task_management/views/splash_screen.dart';
import 'package:provider/provider.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.getTheme,
          onGenerateRoute: (settings) => AppRoute.appRoutes(settings),
          initialRoute: SplashScreen.name,
        ),
      ),
    );
  }
}
