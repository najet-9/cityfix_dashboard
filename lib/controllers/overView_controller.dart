import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dashboard_stats_model.dart';

class DashboardController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DashboardStatsModel? stats;
  bool isLoading = true;
  String? errorMessage;

  final List<StreamSubscription> _subscriptions = [];

  int _totalReports = 0;
  int _resolved = 0;
  int _pending = 0;
  int _activeCitizens = 0;

  // Category counters (Added _parks)
  int _roads = 0, _lighting = 0, _water = 0, _waste = 0, _parks = 0, _other = 0;

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

        // Reset and calculate category counts every time this stream fires
        _roads = 0;
        _lighting = 0;
        _water = 0;
        _waste = 0;
        _parks = 0; // Added for Parks
        _other = 0;

        for (var doc in snap.docs) {
          String category = (doc.data()['category'] ?? '')
              .toString()
              .toLowerCase();

          if (category == 'roads') {
            _roads++;
          } else if (category == 'lighting') {
            _lighting++;
          } else if (category == 'water') {
            _water++;
          } else if (category == 'waste') {
            _waste++;
          } else if (category == 'parks' || category == 'recreation') {
            _parks++; // Logic for the new "Parks" card
          } else {
            _other++;
          }
        }

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

  void _onStreamUpdate() {
    if (_readyCount < _totalStreams) _readyCount++;

    if (_readyCount == _totalStreams) {
      isLoading = false;
      errorMessage = null;
      stats = DashboardStatsModel(
        totalReports: _totalReports,
        resolved: _resolved,
        pending: _pending,
        activeCitizens: _activeCitizens,
        // Passing the new category values to the model
        roads: _roads,
        lighting: _lighting,
        water: _water,
        waste: _waste,
        parks: _parks, // Added
        other: _other,
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
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}
