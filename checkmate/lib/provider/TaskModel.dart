import 'dart:convert';

import 'package:checkmate/library/globals.dart' as globals;
import 'package:checkmate/model/Task.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskModel extends ChangeNotifier {
  TaskModel() {
    initState();
  }

  void initState() {
    loadTasksFromCache();
  }

  final List<Task> _doneTasks = [];
  final Map<String, List<Task>> _todoTasks = {
    globals.late: [],
    globals.today: [],
    globals.tomorrow: [],
    globals.thisWeek: [],
    globals.nextWeek: [],
    globals.thisMonth: [],
    globals.later: [],
  };

  Map<String, List<Task>> get todoTasks => _todoTasks;
  List<Task> get doneTasks => _doneTasks;

  void add(Task task) {
    print("id: ${task.id}");
    String key = guessTodoKeyFromDate(task.deadline);
    if (_todoTasks.containsKey(key)) {
      _todoTasks[key]!.add(task);
      notifyListeners();
    }
  }

  int countTasksByDate(DateTime datetime) {
    String key = guessTodoKeyFromDate(datetime);
    if (_todoTasks.containsKey(key)) {
      return _todoTasks[key]!
          .where((task) =>
              task.deadline.day == datetime.day &&
              task.deadline.month == datetime.month &&
              task.deadline.year == datetime.year)
          .length;
    }
    return 0;
  }

  void markAsDone(String key, Task task) {
    _doneTasks.add(task);
    syncDoneTaskToCache(task);
    _todoTasks[key]?.removeWhere((element) => element.id == task.id);

    print("Done Tasks: ${_doneTasks.map((task) => task.title).toList()}");
    notifyListeners();
  }

  void markAsChecked(String key, int index) {
    _todoTasks[key]?[index].status = true;
    notifyListeners();
  }

  String guessTodoKeyFromDate(DateTime deadline) {
    if (deadline.isPast && !deadline.isToday) {
      return globals.late;
    } else if (deadline.isToday) {
      return globals.today;
    } else if (deadline.isTomorrow) {
      return globals.tomorrow;
    } else if (deadline.getWeek == DateTime.now().getWeek &&
        deadline.year == DateTime.now().year) {
      return globals.thisWeek;
    } else if (deadline.getWeek == DateTime.now().getWeek + 1 &&
        deadline.year == DateTime.now().year) {
      return globals.nextWeek;
    } else if (deadline.isThisMonth) {
      return globals.thisMonth;
    } else {
      return globals.later;
    }
  }

  Future<void> addTaskToCache(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    List<Task> tasksList = await getCacheValuesByKey(globals.todoTasksKey);
    tasksList.add(task);
    await prefs.setString(globals.todoTasksKey, json.encode(tasksList));
  }

  Future<void> loadTasksFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(globals.todoTasksKey)) {
      final String? data = prefs.getString(globals.todoTasksKey);
      List<dynamic> oldTasks = json.decode(data!);
      List<Task> tasksList =
          List<Task>.from(oldTasks.map((element) => Task.fromJson(element)));
      for (var task in tasksList) {
        add(task);
      }
    }
  }

  Future<void> syncDoneTaskToCache(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    List<Task> tasksList = await getCacheValuesByKey(globals.todoTasksKey);
    tasksList.removeWhere((element) => element.id == task.id);
    await prefs.setString(globals.todoTasksKey, json.encode(tasksList));

    List<Task> doneList = await getCacheValuesByKey(globals.doneTasksKey);
    doneList.add(task);
    await prefs.setString(globals.doneTasksKey, json.encode(doneList));

    print("Done Tasks Cache: ${prefs.getString(globals.doneTasksKey)}");
  }

  Future<List<Task>> getCacheValuesByKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      final String? data = prefs.getString(key);
      List<dynamic> oldTasks = json.decode(data!);
      return List<Task>.from(oldTasks.map((element) => Task.fromJson(element)));
    }
    return [];
  }
}
