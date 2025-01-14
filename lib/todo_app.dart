import 'package:flutter/material.dart';
import 'package:todo_app/presentation/screens/todo_home_screen.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoHomeScreen(),
    );
  }
}
