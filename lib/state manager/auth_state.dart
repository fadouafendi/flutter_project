import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';

import '../Home.dart';
import '../LoginPage.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    
    return StreamBuilder<User?>(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          
        
        }
        
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}