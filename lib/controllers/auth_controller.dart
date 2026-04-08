import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AdminAuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  // [1] Login
  Future<void> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Please fill in all fields');
    }

    isLoading = true;
    notifyListeners();

    try {
      // [A] Firebase credentials check
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // [B] Firestore admin check
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(credential.user!.uid)
          .get();

      if (!adminDoc.exists) {
        await _auth.signOut();
        throw Exception('Access denied. This account is not authorized.');
      }

      // [C] Success — controller is done, view handles navigation
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          throw Exception(
            'Access denied. This account is not authorized.',
          ); // ← same message
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
}
