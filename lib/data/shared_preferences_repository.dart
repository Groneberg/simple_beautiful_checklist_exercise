import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';

class SharedPreferencesRepository implements DatabaseRepository {
  static final SharedPreferencesRepository _instance =
      SharedPreferencesRepository._internal();
  SharedPreferencesRepository._internal();
  
  List<String> _tasks = [];

  static SharedPreferencesRepository get instance => _instance;

  late SharedPreferences _prefs;

  factory SharedPreferencesRepository() {
    return _instance;
  }

  Future<void> initializePersistence() async {
    _prefs = await SharedPreferences.getInstance();
    _tasks += _prefs.getStringList('tasks') ?? [];
  }

  Future<void> _persistTasks() async {
    try {
      await _prefs.setStringList('tasks', _tasks);
    } catch (e) {
      log("Fehler beim Speichern der Task-Liste: $e");
    }
  }

  @override
  Future<void> addItem(String item) async {
    _tasks.add(item);
    await _persistTasks();
  }

  @override
  Future<void> deleteItem(int index) async {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      await _persistTasks();
    } else {
      log("Fehler beim Löschen: Ungültiger Index $index");
    }
  }

  @override
  Future<void> editItem(int index, String newItem) async {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = newItem;
      await _persistTasks();
    } else {
      log("Fehler beim Bearbeiten: Ungültiger Index $index");
    }
  }

  @override
  Future<int> getItemCount() async {
    return _tasks.length;
  }

  @override
  Future<List<String>> getItems() async {
    return _tasks;
  }
}
