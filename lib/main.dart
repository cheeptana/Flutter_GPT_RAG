import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_register_app/Screen/HomeScreen.dart';
import 'package:flutter_register_app/Screen/Specific_Modle_Screen.dart';
import 'Screen/General_Modle_Screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(defaultTargetPlatform == TargetPlatform.android) {
  await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDWiuykpMlzdPDnyzRq_pg3QZvte8Qq4yk",
        authDomain: "flutter-registerdata.firebaseapp.com",
        projectId: "flutter-registerdata",
        storageBucket: "flutter-registerdata.firebasestorage.app",
        messagingSenderId: "587032935514",
        appId: "1:587032935514:web:14969be1ac8b90065eec63"
      ),
    );
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpecificModelScreen(),
    );
  }
}

