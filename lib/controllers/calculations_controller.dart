import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/calculations_model.dart';

class AdminCalculationsController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DashboardStats _stats = DashboardStats.empty();
  bool _isLoading = false;

  DashboardStats get stats => _stats;
  bool get isLoading => _isLoading;

  Future<void> fetchStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Total reports
      final reportsSnap = await _db.collection('reports').count().get();
      final total = reportsSnap.count ?? 0;

      // 2. Resolution rate
      final resolvedSnap = await _db
          .collection('reports')
          .where('status', isEqualTo: 'resolved')
          .count()
          .get();
      final resolved = resolvedSnap.count ?? 0;

      final rate = total > 0 ? '${((resolved / total) * 100).round()}%' : '0%';

      // 3. Distinct wilayas by parsing the address field
      final reportsAllSnap = await _db.collection('reports').get();
      final wilayas = reportsAllSnap.docs
          .map((d) {
            final address = d.data()['address'] as String?;
            if (address == null) return null;
            final parts = address.split(',');
            if (parts.length < 2) return null;

            return parts[1]
                .trim()
                .replaceAll(
                  ' Province',
                  '',
                ) // English: "Tlemcen Province" → "Tlemcen"
                .replaceAll(
                  'Wilaya de ',
                  '',
                ) // French: "Wilaya de Tlemcen" → "Tlemcen"
                .replaceAll('wilaya de ', '') // lowercase safety
                .trim(); // clean any leftover spaces
          })
          .whereType<String>()
          .toSet()
          .length;

      _stats = DashboardStats(
        totalReports: total,
        resolutionRate: rate,
        totalWilayas: wilayas,
      );
    } catch (e) {
      debugPrint('Calculations fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
