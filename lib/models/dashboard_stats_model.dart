// lib/models/dashboard_stats_model.dart

class DashboardStatsModel {
  final int totalReports;
  final int resolved;
  final int pending;
  final int activeCitizens;

  const DashboardStatsModel({
    required this.totalReports,
    required this.resolved,
    required this.pending,
    required this.activeCitizens,
  });
}
