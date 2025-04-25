import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/state_manager/auth_state.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/SignupScreen.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Wrap your initialize call in a function that swallows a duplicate-app error:
Future<FirebaseApp> _initFirebase() async {
  try {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      // Someone already called initializeApp; just grab the default
      return Firebase.app();
    }
    rethrow;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await _initFirebase(); // never crashes on duplicate-app now
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Matcher',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthWrapper(),
      routes: {
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
