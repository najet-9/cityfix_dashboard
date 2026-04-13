class DashboardStats {
  final int totalReports;
  final String resolutionRate;
  final int totalWilayas;

  const DashboardStats({
    required this.totalReports,
    required this.resolutionRate,
    required this.totalWilayas,
  });

  factory DashboardStats.empty() => const DashboardStats(
    totalReports: 0,
    resolutionRate: '—',
    totalWilayas: 0,
  );
}
