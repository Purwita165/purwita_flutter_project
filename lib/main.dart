// 01
import 'package:flutter/material.dart';
import 'pages/todo_page.dart';

// 02
void main() {
  runApp(const MyApp());
}

// 03
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TodoPage(),
    );
  }
}
