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

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      reports: json['reports'] ?? 0,
      resolvedPercentage: json['resolvedPercentage'] ?? 0,
      chartData: List<double>.from(json['chartData']?.map((x) => x.toDouble()) ?? []),
    );
  }
}
