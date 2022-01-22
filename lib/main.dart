import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview_todo/todo_manager.dart';
import 'package:interview_todo/todo_model.dart';
import 'package:interview_todo/todo_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter('hive');
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox('todo');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoManager()),
      ],
      child: MaterialApp(
        home: TodoScreen(),
      ),
    ),
  );
}
