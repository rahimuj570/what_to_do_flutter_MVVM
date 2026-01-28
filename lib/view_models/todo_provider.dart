import 'package:flutter/material.dart';
import 'package:mvvm_task_management/models/todo_model.dart';
import 'package:mvvm_task_management/services/db_services.dart';
import 'package:sqflite/sqflite.dart';

class TodoProvider extends ChangeNotifier {
  bool _isFetchingTodod = false;
  final List<TodoModel> _todoList = [];

  List get getTodoList => _todoList;
  bool get getIsFetching => _isFetchingTodod;
  Future<void> fetchTodo() async {
    _isFetchingTodod = true;
    notifyListeners();
    DbServices dbServices = DbServices();
    Database db = await dbServices.getDatabase;

    List<Map<String, dynamic>> todos = await db.query(dbServices.todoTableName);
    for (var t in todos) {
      _todoList.add(TodoModel.fromJson(t));
    }
    _isFetchingTodod = false;
    notifyListeners();
  }

  bool _isCraetingTodo = false;
  bool get getIsCreatingTodo => _isCraetingTodo;
  Future<int> addTodo(TodoModel model) async {
    int count = 0;
    _isCraetingTodo = true;
    notifyListeners();

    DbServices dbServices = DbServices();
    Database db = await dbServices.getDatabase;

    count = await db.insert(dbServices.todoTableName, model.toJson());

    _isCraetingTodo = false;
    notifyListeners();
    fetchTodo();
    return count;
  }
}
