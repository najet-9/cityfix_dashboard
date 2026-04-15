class DashboardStatsModel {
  final int totalReports;
  final int resolved;
  final int pending;
  final int activeCitizens;
  // Category counts
  final int roads;
  final int lighting;
  final int water;
  final int waste;
  final int other;
  final int parks; // Added for Parks category

  const DashboardStatsModel({
    required this.totalReports,
    required this.resolved,
    required this.pending,
    required this.activeCitizens,
    this.roads = 0,
    this.lighting = 0,
    this.water = 0,
    this.waste = 0,
    this.other = 0,
    this.parks = 0, // Added for Parks category
  });
}
