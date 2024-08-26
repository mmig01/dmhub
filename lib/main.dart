import 'package:flutter/material.dart';
import 'package:phomu/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xffe4e3e3),
      ),
      home: const HomeScreen(
        isFirstNavigated: true,
      ),
    );
  }
}
