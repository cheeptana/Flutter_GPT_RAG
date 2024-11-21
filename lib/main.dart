import 'package:flutter/material.dart';

import 'Screen/General_Modle_Screen.dart';



void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GeneralModleScreen(),
    );
  }
}

