// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, prefer_final_fields

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_todo/todo_detail_screen.dart';
import 'package:interview_todo/todo_manager.dart';
import 'package:interview_todo/todo_model.dart';
import 'package:provider/provider.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen({Key? key}) : super(key: key);
  var _newTitle, _newDescription, _formKey = GlobalKey<FormState>();

  File? image;
  XFile? _newImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Todo List"),
        centerTitle: true,
      ),
      bottomSheet: BottomNavigationBar(
          backgroundColor: Colors.blueGrey,
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Text(
                  "Total Todo: " +
                      context.watch<TodoManager>().todos.length.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.white)),
                    child: const Text('Add Todo'),
                    onPressed: () => addTodoDialog(context)),
                label: "")
          ]),
      backgroundColor: Colors.blueGrey.shade50,
      body: context.watch<TodoManager>().todos.isEmpty
          ? Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<TodoManager>().getTodosAll();
                  if (context.read<TodoManager>().todos.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (context) => const SimpleDialog(
                              title: Text("Plese Add, Todo List is Empty\n"),
                            ));
                  } else {}
                },
                child: const Text(
                  'Get Todo List!',
                  style: TextStyle(fontSize: 16),
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith(
                        (states) => const CircleBorder()),
                    minimumSize: MaterialStateProperty.resolveWith(
                        (states) => const Size(70, 120)),
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
              ),
            )
          : ListView(
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 90),
              children: context
                  .watch<TodoManager>()
                  .todos
                  .map(
                    (e) => GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoDetailScreen(
                              e: e,
                            ),
                          )),
                      child: Card(
                        elevation: 10,
                        shape: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            const Divider(color: Colors.white),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const VerticalDivider(),
                                Text(
                                  e.title.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const VerticalDivider(),
                                Text(
                                  e.description.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                const VerticalDivider(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const VerticalDivider(),
                                CircleAvatar(
                                  backgroundColor: e.image == null
                                      ? Colors.blueGrey.shade50
                                      : Colors.transparent,
                                  radius: 40,
                                  child: e.image == null
                                      ? const Text(' Didn\'t Add \n Photo')
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            File(e.image!),
                                            filterQuality: FilterQuality.high,
                                            alignment: Alignment.centerRight,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                ),

                                const VerticalDivider(
                                  width: 150,
                                ),
                                IconButton(
                                    onPressed: () => context
                                        .read<TodoManager>()
                                        .removeFromList(e),
                                    icon: const Icon(
                                      Icons.highlight_remove,
                                      color: Colors.red,
                                    )),
                                // const VerticalDivider(),
                              ],
                            ),
                            const Divider(color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  addTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
            scrollable: true,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            actionsOverflowButtonSpacing: 7,
            title: const Text('Add Todo'),
            backgroundColor: Colors.white,
            elevation: 100,
            actions: [
              TextFormField(
                validator: RequiredValidator(errorText: "Required"),
                decoration: const InputDecoration(label: Text('Add Title')),
                onChanged: (value) => _newTitle = value,
              ),
              TextFormField(
                validator: RequiredValidator(errorText: "Required"),
                decoration:
                    const InputDecoration(label: Text('Add Description')),
                onChanged: (value) => _newDescription = value,
              ),
              OutlinedButton(
                  onPressed: () => pickImage(), child: const Text('Add Photo')),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey)),
                  ),
                  const VerticalDivider(),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        TodoModel todo = TodoModel(
                          description: _newDescription.toString(),
                          image: _newImage?.path,
                          title: _newTitle.toString(),
                        );
                        context.read<TodoManager>().addToList(todo);
                        _newTitle = null;
                        _newDescription = null;
                        _newImage = null;
                        Navigator.pop(context);
                      } else {}
                    },
                    child: const Text('Add'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                  ),
                  const VerticalDivider()
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future pickImage() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      var imageTemproray = File(image.path);
      this.image = imageTemproray;
      _newImage = image;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
