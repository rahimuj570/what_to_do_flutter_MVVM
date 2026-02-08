import 'package:flutter/material.dart';
import 'package:mvvm_task_management/models/todo_model.dart';
import 'package:mvvm_task_management/services/db_services.dart';
import 'package:mvvm_task_management/services/notification_servicee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class TodoProvider extends ChangeNotifier {
  bool _isFetchingTodod = false;
  int currentStatusTab = 0;
  bool textRecognizing = false;
  bool _sortDESC = true;
  double score = 0.0;
  List<TodoModel> _todoInProgressList = [];
  List<TodoModel> _todoCompletedList = [];
  List<TodoModel> _todoCancelledList = [];
  List<TodoModel> _todoMissedList = [];

  TodoProvider() {
    _fetchSavedSort();
  }

  DbServices dbServices = DbServices();

  set changeTextREcognizingStatus(bool status) {
    textRecognizing = status;
    notifyListeners();
  }

  void changeCurrentStatusTab(int status) {
    currentStatusTab = status;
    if (currentStatusTab == 3) {
      fetchTodo();
    } else {
      notifyListeners();
    }
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
        return _todoMissedList;
    }
  }

  bool get getIsFetching => _isFetchingTodod;
  Future<void> fetchTodo() async {
    _todoInProgressList.clear();
    _todoCancelledList.clear();
    _todoCompletedList.clear();
    _todoMissedList.clear();
    _isFetchingTodod = true;
    Database db = await dbServices.getDatabase;

    List<Map<String, dynamic>> todos = await db.query(
      dbServices.todoTableName,
      orderBy: _sortDESC ? 'deadline desc' : 'deadline',
    );
    for (Map<String, dynamic> t in todos) {
      bool expire = false;
      if (t['deadline'] != null) {
        if (DateTime.now().isAfter(
          DateTime.fromMillisecondsSinceEpoch(t['deadline']),
        )) {
          expire = true;
        }
      }
      if (t['status'] == 0 && expire == false) {
        _todoInProgressList.add(TodoModel.fromJson(t));
      } else if (t['status'] == 1 && expire == false) {
        _todoCompletedList.add(TodoModel.fromJson(t));
      } else if (t['status'] == 2 && expire == false) {
        _todoCancelledList.add(TodoModel.fromJson(t));
      } else {
        if (t['status'] == 3) {
          _todoMissedList.add(TodoModel.fromJson(t));
        } else {
          Map<String, dynamic> tmp = Map<String, dynamic>.from(t);
          tmp['status'] = 3;
          _todoMissedList.add(TodoModel.fromJson(tmp));
          await db.update(
            dbServices.todoTableName,
            tmp,
            where: 'id=?',
            whereArgs: [tmp['id']],
          );
        }
      }
    }
    score = _calculateScore();
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

    if (count != 0 && model.deadline != null) {
      _createNotification(count, model);
    }
    _isCraetingTodo = false;
    await fetchTodo();
    return count;
  }

  bool _isUpdatingTodo = false;
  bool get getIsUpdatingTodo => _isUpdatingTodo;
  Future<int> updateTodo(TodoModel model) async {
    int count = 0;
    _isUpdatingTodo = true;
    notifyListeners();

    DbServices dbServices = DbServices();
    Database db = await dbServices.getDatabase;

    count = await db.update(
      dbServices.todoTableName,
      model.toJson(),
      where: 'id=?',
      whereArgs: [model.id],
    );

    if (count != 0 && model.deadline != null) {
      _createNotification(model.id!, model);
    }

    _isUpdatingTodo = false;
    notifyListeners();
    fetchTodo();

    return count;
  }

  Future<int> deleteTodo(int todoId, int status) async {
    Database db = await dbServices.getDatabase;
    int count = await db.delete(
      dbServices.todoTableName,
      where: 'id=?',
      whereArgs: [todoId],
    );

    if (count != 0) {
      if (status == 0) {
        _todoInProgressList.removeWhere((element) => element.id == todoId);
      } else if (status == 1) {
        _todoCompletedList.removeWhere((element) => element.id == todoId);
      } else if (status == 2) {
        _todoCancelledList.removeWhere((element) => element.id == todoId);
      } else {
        _todoMissedList.removeWhere((element) => element.id == todoId);
      }
      score = _calculateScore();
      _cancelNotification(todoId);
      notifyListeners();
    }
    return count;
  }

  Future<int> changeTodoStatus(int newStatus, TodoModel model) async {
    int count = 0;
    Database db = await dbServices.getDatabase;
    int oldStatus = model.status;
    model.status = newStatus;
    count = await db.update(
      dbServices.todoTableName,
      model.toJson(),
      where: 'id=?',
      whereArgs: [model.id],
    );

    if (count != 0) {
      switch (oldStatus) {
        case 0:
          {
            _todoInProgressList.removeWhere(
              (element) => element.id == model.id,
            );
            break;
          }
        case 1:
          {
            _todoCompletedList.removeWhere((element) => element.id == model.id);
            break;
          }

        case 2:
          {
            _todoCancelledList.removeWhere((element) => element.id == model.id);
          }
        default:
          {
            _todoMissedList.removeWhere((element) => element.id == model.id);
          }
      }

      _cancelNotification(model.id!);

      switch (newStatus) {
        case 0:
          {
            _todoInProgressList.add(model);
            break;
          }
        case 1:
          {
            _todoCompletedList.add(model);
            break;
          }
        case 3:
          {
            _todoMissedList.add(model);
            break;
          }

        default:
          {
            _todoCancelledList.add(model);
          }
      }
      score = _calculateScore();
      notifyListeners();
    }

    return count;
  }

  double _calculateScore() {
    int inProgress = getTodoList(0).length;
    int complete = getTodoList(1).length;

    int cancel = getTodoList(2).length;
    int miss = getTodoList(3).length;

    int total = (inProgress + complete + miss + cancel) * 2;
    double res =
        ((inProgress * 1 + complete * 2 + (cancel * -1) + (miss * -2)) /
            total) *
        100;
    return res;
  }

  // SHORT TODO

  bool get isDESC => _sortDESC;

  void toggleSort() async {
    _sortDESC = !_sortDESC;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isDESC', _sortDESC);

    _todoInProgressList = _todoInProgressList.reversed.toList();
    _todoCancelledList = _todoCancelledList.reversed.toList();
    _todoCompletedList = _todoCompletedList.reversed.toList();
    _todoMissedList = _todoMissedList.reversed.toList();
    notifyListeners();
  }

  Future<void> _fetchSavedSort() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _sortDESC = sharedPreferences.getBool('isDESC') ?? true;
    notifyListeners();
  }

  void _cancelNotification(int id) async {
    await NotificationService.cancelNotification(id * 10 + 0);
  }

  void _createNotification(int id, TodoModel model) {
    if (DateTime.fromMillisecondsSinceEpoch(
      model.deadline! - (10 * 60 * 1000),
    ).isAfter(DateTime.now())) {
      debugPrint('creted schedule notification');
      NotificationService.showNotification(
        id: id * 10 + 2,
        title: 'Reminder - 10 minutes left',
        body: model.todo,
        deadline: (model.deadline! - (10 * 60 * 1000)),
      );
    }

    //Before 30Min
    if (DateTime.fromMillisecondsSinceEpoch(
      model.deadline! - (30 * 60 * 1000),
    ).isAfter(DateTime.now())) {
      debugPrint('creted schedule notification');
      NotificationService.showNotification(
        id: id * 10 + 1,
        title: 'Reminder - 30 minutes left',
        body: model.todo,
        deadline: (model.deadline! - (30 * 60 * 1000)),
      );
    }

    //After end
    NotificationService.showNotification(
      id: id * 10 + 0,
      title: 'Missed',
      body: 'You missed - ${model.todo}',
      deadline: (model.deadline!),
    );
  }
}
