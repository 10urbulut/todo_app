// ignore_for_file: prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:interview_todo/todo_model.dart';

class TodoManager extends ChangeNotifier {
  TodoModel? _todo;
  List<TodoModel> _todos = [];

  // List<TodoModel> _todos = Hive.box('todo').get(0);
  Box boxTodo = Hive.box('todo');

  void addToList(TodoModel todo) async {
    await boxTodo.add(todo);
    getTodosAll();

    notifyListeners();
  }

  void removeFromList(TodoModel todo) async {
    await boxTodo.delete(todo.key);
    getTodosAll();
    notifyListeners();
  }

  Future getTodosAll() async {
    // _todos = await Hive.box('todo').get(3);
    _todos.clear();
    _todos.addAll(boxTodo.values.cast<TodoModel>());
    notifyListeners();
  }

  List<TodoModel> get todos => _todos;
}
