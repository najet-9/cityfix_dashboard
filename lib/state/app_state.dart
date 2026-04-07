import 'package:flutter/material.dart';

class DashboardState extends ChangeNotifier {
  String _currentPage = 'overview';

  String get currentPage => _currentPage;

  void setPage(String page) {
    if (_currentPage != page) {
      _currentPage = page;
      notifyListeners();
    }
  }
}

class AuthState extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
