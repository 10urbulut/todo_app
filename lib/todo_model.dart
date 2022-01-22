import 'dart:io';

import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  TodoModel({
    this.description,
    this.image,
    this.title,
  });
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? description;
  @HiveField(2)
  String? image;
}

@HiveType(typeId: 1)
class TodoModelList extends HiveObject {
  TodoModelList({this.todos});
  @HiveField(0)
  List<TodoModel>? todos;
}
