import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminAuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  // [1] Login========================================================
  Future signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Please fill in all fields');
    }
    try {
      isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          throw Exception('Invalid email or password');
        case 'invalid-email':
          throw Exception('Invalid email address');
        default:
          throw Exception('Something went wrong. Try again');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // [2] Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // [3] Auth state
  Stream<User?> get authState => _auth.authStateChanges();
}
