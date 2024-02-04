import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_api_todo_app/View/todo_home_screen.dart';
import 'package:rest_api_todo_app/controller/add_screen_provider.dart';
import 'package:rest_api_todo_app/controller/tod_home_screen.provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AddScreenProvider()),
        ChangeNotifierProvider(create: (context) => TodoHomeProvider())
      ],
      child: MaterialApp(
        home: const ToDoListScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
      ),
    );
  }
}
