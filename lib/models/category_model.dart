class CategoryModel {
  final String name;
  final String icon;
  final int reports;
  final int resolvedPercentage;
  final List<double> chartData; // Pour les petites barres bleues

  CategoryModel({
    required this.name,
    required this.icon,
    required this.reports,
    required this.resolvedPercentage,
    required this.chartData,
  });
}
