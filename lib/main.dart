import 'package:flutter/material.dart';
import 'package:tally_task/screens/counter.dart';

// ignore: unused_import
import 'package:tally_task/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
