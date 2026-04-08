import 'package:admin_dashboard/models/category_model.dart';

class CategoryController {
  List<CategoryModel> getCategories() {
    return [
      CategoryModel(
        name: "Roads & Potholes",
        icon: "🛣️",
        reports: 329,
        resolvedPercentage: 68,
        chartData: [0.2, 0.5, 0.8, 0.4, 0.9, 0.3],
      ),
      CategoryModel(
        name: "Street Lighting",
        icon: "💡",
        reports: 289,
        resolvedPercentage: 75,
        chartData: [0.4, 0.3, 0.6, 0.8, 0.5, 0.7],
      ),
      CategoryModel(
        name: "Water & Drainage",
        icon: "💧",
        reports: 211,
        resolvedPercentage: 60,
        chartData: [0.5, 0.4, 0.3, 0.5, 0.6, 0.4],
      ),
      CategoryModel(
        name: "Waste & Sanitation",
        icon: "🗑️",
        reports: 183,
        resolvedPercentage: 55,
        chartData: [0.3, 0.6, 0.4, 0.7, 0.3, 0.5],
      ),
      CategoryModel(
        name: "Parks & Gardens",
        icon: "🌳",
        reports: 132,
        resolvedPercentage: 80,
        chartData: [0.7, 0.8, 0.9, 0.6, 0.8, 0.9],
      ),
      CategoryModel(
        name: "Other Issues",
        icon: "📦",
        reports: 96,
        resolvedPercentage: 45,
        chartData: [0.2, 0.3, 0.2, 0.4, 0.3, 0.2],
      ),
    ];
  }
}
