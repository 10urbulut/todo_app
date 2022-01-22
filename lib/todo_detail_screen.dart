// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:interview_todo/todo_model.dart';

class TodoDetailScreen extends StatelessWidget {
  TodoDetailScreen({Key? key, required this.e}) : super(key: key);
  TodoModel e;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Todo Detail"),
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey.shade50,
      body: ListView(
          padding:
              const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 90),
          children: [
            Card(
              elevation: 10,
              shape: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  const Divider(color: Colors.white),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      e.image == null
                          ? const Text(' Didn\'t Add \n Photo')
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(e.image!),
                                cacheHeight: 200,
                                cacheWidth: 200,
                                filterQuality: FilterQuality.high,
                                alignment: Alignment.centerRight,
                                fit: BoxFit.scaleDown,
                              ),
                            ),

                      // const VerticalDivider(),
                    ],
                  ),
                  const Divider(color: Colors.white),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const VerticalDivider(),
                      Text(
                        e.title.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const VerticalDivider(),
                    ],
                  ),
                  const Divider(color: Colors.white),
                ],
              ),
            ),
          ]),
    );
  }
}
