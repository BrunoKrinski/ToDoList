import 'package:flutter/material.dart';
import 'package:todo_list/views/home_view.dart';

void main() {
  runApp(const ToDoList());
}

class ToDoList extends StatelessWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDoList',
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}