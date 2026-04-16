import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UsersController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CitizenUser> citizens = [];
  List<CitizenUser> filteredCitizens = [];
  bool isLoading = true;
  String searchQuery = '';

  UsersController() {
    _listenToUsers();
  }

  void _listenToUsers() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      citizens = snapshot.docs
          .map((doc) => CitizenUser.fromFirestore(doc))
          .toList();

      applySearch(searchQuery);
      isLoading = false;
      notifyListeners();
    });
  }

  void applySearch(String query) {
    searchQuery = query;
    if (query.isEmpty) {
      filteredCitizens = citizens;
    } else {
      final q = query.toLowerCase();
      filteredCitizens = citizens.where((user) {
        return user.name.toLowerCase().contains(q) ||
            user.email.toLowerCase().contains(q) ||
            user.wilaya.toLowerCase().contains(q);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  int get totalCitizens => citizens.length;
}
