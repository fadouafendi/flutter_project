import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;
  bool isLoading = true;
  String? errorMessage;

  AuthProvider() {
    _authService.authStateChanges.listen((u) {
      user = u;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      errorMessage = null;
      await _authService.signInWithEmail(email, password);
    } catch (e) {
      errorMessage =
          e is AuthException ? e.message : 'Une erreur inattendue est survenue';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String name) async {
    isLoading = true;
    notifyListeners();
    try {
      errorMessage = null;
      User? newUser = await _authService.signUpWithEmail(email, password);
      if (newUser != null) {
        await newUser.updateDisplayName(name);
        await newUser.reload();
        user = FirebaseAuth.instance.currentUser;
      }
    } catch (e) {
      errorMessage =
          e is AuthException ? e.message : 'Une erreur inattendue est survenue';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    isLoading = true;
    notifyListeners();
    try {
      errorMessage = null;
      await _authService.signinWithGoogle();
    } catch (e) {
      errorMessage =
          e is AuthException ? e.message : 'Échec de la connexion Google';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
