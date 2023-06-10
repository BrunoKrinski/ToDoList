import 'package:flutter/material.dart';
import 'package:todo_list/views/todo_list_item.dart';

import '../controllers/todo_repository.dart';
import '../models/todo.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Todo? deletedTodo;
  int? deletedTodoPos;
  List<Todo> todos = [];

  final TodoRepository todoRepository = TodoRepository();
  final TextEditingController todoController = TextEditingController();


  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'To-Do List',
                style: TextStyle(
                  fontSize: 70,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: todoController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        labelText: 'Type a To-Do',
                        floatingLabelStyle: TextStyle(
                          color: Colors.blueAccent,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        hintText: 'Study Math',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String text = todoController.text;
                      if (text != "") {
                        Todo todo = Todo(title: text, date: DateTime.now());
                        setState(() {
                          todos.add(todo);
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        fixedSize: Size(100, 51)),
                    child: Text(
                      'Create',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in todos)
                      ToDoListItem(
                        todo: todo,
                        deleteTodo: deleteTodo,
                      )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      child: Text(
                        'You have ${todos.length} pending To-Dos!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: showConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        fixedSize: Size(110, 52)),
                    child: Text(
                      'Delete All!',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteTodo(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'To-Do ${todo.title} removed!',
      ),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Undo!',
        textColor: Colors.blueAccent,
        onPressed: () {
          setState(() {
            todos.insert(deletedTodoPos!, deletedTodo!);
          });
          todoRepository.saveTodoList(todos);
        },
      ),
    ));
    todoRepository.saveTodoList(todos);
  }

  void showConfirmationDialog() {
    if(todos.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Clear all To-Dos?'),
              content: Text('Are you sure to clear all To-Dos?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Text(
                    'Cancel!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      todos.clear();
                    });
                    todoRepository.saveTodoList(todos);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Confirm!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
      );
    }
  }
}