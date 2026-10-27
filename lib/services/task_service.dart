import 'dart:convert';

import 'package:auroria/models/task.dart';
import 'package:auroria/utils/text_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService extends ChangeNotifier {
  final Map<String, List<Task>> _byDay = {};
  String? _email;

  Future<void> load(String email) async {
    _email = email;
    _byDay.clear();
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('tasks_$email');
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((key, value) {
        _byDay[key] = (value as List<dynamic>)
            .map((item) => Task.fromMap(item as Map<String, dynamic>))
            .toList();
      });
    }
    notifyListeners();
  }

  void clear() {
    _email = null;
    _byDay.clear();
    notifyListeners();
  }

  Future<void> _save() async {
    final email = _email;
    if (email == null) return;
    final prefs = await SharedPreferences.getInstance();
    final map = _byDay.map(
      (key, list) => MapEntry(key, list.map((task) => task.toMap()).toList()),
    );
    await prefs.setString('tasks_$email', jsonEncode(map));
  }

  List<Task> tasksOf(DateTime day) {
    final list = List<Task>.from(_byDay[dateKey(day)] ?? const <Task>[]);
    list.sort(compareTasks);
    return list;
  }

  Future<void> add(DateTime day, String title) async {
    final list = _byDay.putIfAbsent(dateKey(day), () => <Task>[]);
    list.add(
      Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title.trim(),
      ),
    );
    notifyListeners();
    await _save();
  }

  Future<void> toggle(DateTime day, String id) async {
    final list = _byDay[dateKey(day)];
    if (list == null) return;
    final index = list.indexWhere((task) => task.id == id);
    if (index < 0) return;
    list[index] = list[index].copyWith(done: !list[index].done);
    notifyListeners();
    await _save();
  }

  Future<void> remove(DateTime day, String id) async {
    final key = dateKey(day);
    final list = _byDay[key];
    if (list == null) return;
    list.removeWhere((task) => task.id == id);
    if (list.isEmpty) {
      _byDay.remove(key);
    }
    notifyListeners();
    await _save();
  }
}