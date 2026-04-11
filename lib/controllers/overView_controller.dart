// lib/controllers/overView_controller.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dashboard_stats_model.dart';

class DashboardController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DashboardStatsModel? stats;
  bool isLoading = true;
  String? errorMessage;

  // Hold all stream subscriptions so we can cancel them in dispose()
  final List<StreamSubscription> _subscriptions = [];

  // Internal counters updated independently by each stream
  int _totalReports = 0;
  int _resolved = 0;
  int _pending = 0;
  int _activeCitizens = 0;

  // Track how many streams have emitted at least once.
  // Only set isLoading = false when all 4 have delivered their first value.
  int _readyCount = 0;
  static const int _totalStreams = 4;

  DashboardController() {
    _listenToStreams();
  }

  void _listenToStreams() {
    // --- Stream 0: total reports ---
    _subscriptions.add(
      _db.collection('reports').snapshots().listen((snap) {
        _totalReports = snap.size;
        _onStreamUpdate();
      }, onError: _onError),
    );

    // --- Stream 1: resolved reports ---
    _subscriptions.add(
      _db
          .collection('reports')
          .where('status', isEqualTo: 'resolved')
          .snapshots()
          .listen((snap) {
            _resolved = snap.size;
            _onStreamUpdate();
          }, onError: _onError),
    );

    // --- Stream 2: pending reports ---
    _subscriptions.add(
      _db
          .collection('reports')
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .listen((snap) {
            _pending = snap.size;
            _onStreamUpdate();
          }, onError: _onError),
    );

    // --- Stream 3: active citizens (all users) ---
    _subscriptions.add(
      _db.collection('users').snapshots().listen((snap) {
        _activeCitizens = snap.size;
        _onStreamUpdate();
      }, onError: _onError),
    );
  }

  // Called every time any stream emits a new value.
  void _onStreamUpdate() {
    // Count how many streams have fired at least once.
    // We increment until we reach _totalStreams, then stop counting.
    if (_readyCount < _totalStreams) _readyCount++;

    // Only publish stats once ALL 4 streams have given us their first value,
    // so the UI never shows partial data (e.g. totalReports=5, resolved=0
    // just because stream 1 fired before stream 2 did).
    if (_readyCount == _totalStreams) {
      isLoading = false;
      errorMessage = null;
      stats = DashboardStatsModel(
        totalReports: _totalReports,
        resolved: _resolved,
        pending: _pending,
        activeCitizens: _activeCitizens,
      );
      notifyListeners();
    }
  }

  void _onError(Object error) {
    errorMessage = 'Failed to load stats: $error';
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    // Cancel all Firestore listeners to avoid memory leaks.
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}
