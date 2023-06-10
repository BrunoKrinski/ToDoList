import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class ToDoListItem extends StatelessWidget {
  const ToDoListItem({
    Key? key,
    required this.todo,
    required this.deleteTodo,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) deleteTodo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.20,
          motion: BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                deleteTodo(todo);
              },
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(4),
              padding: EdgeInsets.all(0),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('dd/mm/yyyy - HH:mm').format(todo.date),
                style: TextStyle(
                  fontSize: 10,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}