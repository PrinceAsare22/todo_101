import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo.dart';

class TodoStorage {
  final String _key = 'todos';

  // Save a list of todos to SharedPreferences
  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert the list of Todo objects to JSON
    List<String> jsonList =
        todos.map((todo) => json.encode(todo.toMap())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  // Load todos from SharedPreferences
  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    // Convert the JSON strings back to Todo objects
    return jsonList.map((item) => Todo.fromMap(json.decode(item))).toList();
  }

  // Clear all todos
  Future<void> clearTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
