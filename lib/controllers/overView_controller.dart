import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dashboard_stats_model.dart';

class DashboardController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DashboardStatsModel? stats;
  bool isLoading = true;
  String? errorMessage;

  DashboardController() {
    fetchStats();
  }

  Future<void> fetchStats() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        // [0] All reports
        _db.collection('reports').count().get(),

        // [1] Resolved reports
        _db
            .collection('reports')
            .where('status', isEqualTo: 'resolved')
            .count()
            .get(),

        // [2] Pending reports
        _db
            .collection('reports')
            .where('status', isEqualTo: 'pending')
            .count()
            .get(),

        // [3] Total registered users (active citizens)
        _db.collection('users').count().get(),
      ]);

      stats = DashboardStatsModel(
        totalReports: results[0].count ?? 0,
        resolved: results[1].count ?? 0,
        pending: results[2].count ?? 0,
        activeCitizens: results[3].count ?? 0,
      );
    } catch (e) {
      errorMessage = 'Failed to load stats: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
