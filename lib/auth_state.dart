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
        // Handle different connection states properly
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator only while actively waiting for the first response
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If we have data or the connection is done/active, check the user
        final User? user = snapshot.data;

        // If no user or error, go to login page
        if (user == null) {
          return LoginPage();
        }

        // User is logged in, go to home
        return Home();
      },
    );
  }
}
