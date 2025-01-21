import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_register_app/ConnectAPI/api_keys.dart';
import 'package:flutter_register_app/Screen/HomeScreen.dart';
import 'package:flutter_register_app/Screen/Specific_Modle_Screen.dart';
import 'Screen/General_Modle_Screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: Config.apiKey,
          authDomain: Config.authDomain,
          projectId: Config.projectId,
          storageBucket: Config.storageBucket,
          messagingSenderId: Config.messagingSenderId,
          appId: Config.appId),
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
      home: SpecificModelScreen2(),
    );
  }
}
