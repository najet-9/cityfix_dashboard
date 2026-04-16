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

  // ── Variables catégories (manquaient = cause des erreurs) ──
  int _roads = 0;
  int _lighting = 0;
  int _water = 0;
  int _waste = 0;
  int _parks = 0;
  int _other = 0;

  int _readyCount = 0;
  static const int _totalStreams = 4;

  // ── Chart data ──
  Map<int, int> monthlyReports = {};
  Map<int, int> monthlyResolved = {};
  bool isLoadingChart = true;

  DashboardController() {
    _listenToStreams();
    fetchMonthlyData();
  }

  void _listenToStreams() {
    _subscriptions.add(
      _db.collection('reports').snapshots().listen((snap) {
        _totalReports = snap.size;

        _roads = 0;
        _lighting = 0;
        _water = 0;
        _waste = 0;
        _parks = 0;
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
            _parks++;
          } else {
            _other++;
          }
        }

        _onStreamUpdate();
      }, onError: _onError),
    );

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
        roads: _roads,
        lighting: _lighting,
        water: _water,
        waste: _waste,
        parks: _parks,
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

  Future<void> fetchMonthlyData() async {
    isLoadingChart = true;
    notifyListeners();

    for (int i = 1; i <= 12; i++) {
      monthlyReports[i] = 0;
      monthlyResolved[i] = 0;
    }

    try {
      int currentYear = DateTime.now().year;

      QuerySnapshot snapshot = await _db
          .collection('reports')
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(
              DateTime(currentYear, 1, 1),
            ),
          )
          .where(
            'createdAt',
            isLessThan: Timestamp.fromDate(DateTime(currentYear + 1, 1, 1)),
          )
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['createdAt'] == null) continue;

        Timestamp ts = data['createdAt'] as Timestamp;
        int month = ts.toDate().month;

        monthlyReports[month] = (monthlyReports[month] ?? 0) + 1;

        if (data['status'] == 'resolved') {
          monthlyResolved[month] = (monthlyResolved[month] ?? 0) + 1;
        }
      }
    } catch (e) {
      errorMessage = 'Failed to load chart data: $e';
    }

    isLoadingChart = false;
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
