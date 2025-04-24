import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:flutter_application_1/firebase_options.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized(); // Required for async initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Loads config from firebase_options.dart
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
   MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: LoginPage()
        
      ),
    );
  }
}
