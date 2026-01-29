import 'package:flutter/material.dart';
import 'package:mvvm_task_management/models/todo_model.dart';
import 'package:mvvm_task_management/services/db_services.dart';
import 'package:sqflite/sqflite.dart';

class TodoProvider extends ChangeNotifier {
  bool _isFetchingTodod = false;
  int currentStatusTab = 0;
  final List<TodoModel> _todoInProgressList = [];
  final List<TodoModel> _todoCompletedList = [];
  final List<TodoModel> _todoCancelledList = [];

  DbServices dbServices = DbServices();

  void changeCurrentStatusTab(int status) {
    currentStatusTab = status;
    notifyListeners();
  }

  List getTodoList(int status) {
    switch (status) {
      case 0:
        return _todoInProgressList;
      case 1:
        return _todoCompletedList;
      case 2:
        return _todoCancelledList;
      default:
        return [];
    }
  }

  bool get getIsFetching => _isFetchingTodod;
  Future<void> fetchTodo() async {
    _todoInProgressList.clear();
    _isFetchingTodod = true;
    notifyListeners();
    Database db = await dbServices.getDatabase;

    List<Map<String, dynamic>> todos = await db.query(dbServices.todoTableName);
    for (var t in todos) {
      if (t['status'] == 0) {
        _todoInProgressList.add(TodoModel.fromJson(t));
      } else if (t['status'] == 1) {
        _todoCompletedList.add(TodoModel.fromJson(t));
      } else {
        _todoCancelledList.add(TodoModel.fromJson(t));
      }
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

  Future<int> deleteTodo(int todoId) async {
    Database db = await dbServices.getDatabase;
    int count = await db.delete(
      dbServices.todoTableName,
      where: 'id=?',
      whereArgs: [todoId],
    );

    if (count != 0) {
      _todoInProgressList.removeWhere((element) => element.id == todoId);
      notifyListeners();
    }
    return count;
  }
}
