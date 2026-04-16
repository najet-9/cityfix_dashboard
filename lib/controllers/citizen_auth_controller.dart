import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CitizenAuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String errorMessage = '';

  // Sign Up citoyen
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String wilaya,
  }) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      // 1. Créer le compte Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // 2. Sauvegarder dans Firestore collection 'users'
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'wilaya': wilaya,
        'reports': 0,
        'resolved': 0,
        'online': true,
      });

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _getError(e.code);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Login citoyen
  Future<bool> login({required String email, required String password}) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Mettre online à true
      await _firestore.collection('users').doc(credential.user!.uid).update({
        'online': true,
      });

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _getError(e.code);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Logout citoyen
  Future<void> signOut() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('users').doc(uid).update({'online': false});
    }
    await _auth.signOut();
  }

  String _getError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email already used.';
      case 'weak-password':
        return 'Password too short (min 6 chars).';
      case 'user-not-found':
        return 'No account found.';
      case 'wrong-password':
        return 'Wrong password.';
      case 'invalid-email':
        return 'Invalid email.';
      default:
        return 'Something went wrong.';
    }
  }
}
