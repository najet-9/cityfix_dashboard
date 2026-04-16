import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin_dashboard/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryController {
  // Instance of Firebase Firestore to interact with the database
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetches and groups data from the 'reports' collection in real-time.
  /// This replaces the old mock data with actual backend logic.
  Stream<List<CategoryModel>> getCategoriesStream() {
    return _db.collection('reports').snapshots().map((snapshot) {
      // Temporary map to group reports by their category field found in Firestore
      Map<String, List<DocumentSnapshot>> groupedData = {};

      for (var doc in snapshot.docs) {
        // Accessing the 'category' field from each document
        String catName = doc['category'] ?? 'Other';
        if (!groupedData.containsKey(catName)) {
          groupedData[catName] = [];
        }
        groupedData[catName]!.add(doc);
      }

      // Transform grouped Firestore data into a list of CategoryModel
      return groupedData.entries.map((entry) {
        return CategoryModel(
          name: entry.key,
          icon: _getIconForCategory(entry.key), // Dynamically assign icons
          reports: entry.value.length, // Total count of documents in this group
          resolvedPercentage: _calculateResolved(entry.value), // Logic for resolved stats
          chartData: [0.2, 0.5, 0.4, 0.7, 0.3, 0.5], // Placeholder for visualization
        );
      }).toList();
    });
  }

  /// Assigns a specific emoji icon based on the category name found in Firestore
  String _getIconForCategory(String name) {
    switch (name.toLowerCase()) {
      case 'roads':
      case 'roads & potholes':
        return "🛣️";
      case 'lighting':
      case 'street lighting':
        return "💡";
      case 'water':
      case 'water & drainage':
        return "💧";
      case 'waste':
      case 'waste & sanitation':
        return "🗑️";
      case 'parks':
      case 'parks & gardens':
        return "🌳";
      default:
        return "📦"; // Default icon for other types
    }
  }

  /// Calculates the percentage of resolved reports within a specific category group
  int _calculateResolved(List<DocumentSnapshot> docs) {
    if (docs.isEmpty) return 0;
    
    // Filtering documents where the 'status' field is marked as 'resolved'
    int resolvedCount = docs.where((doc) {
      try {
        return doc['status'] == 'resolved';
      } catch (e) {
        return false;
      }
    }).length;

    // Return the integer percentage
    return ((resolvedCount / docs.length) * 100).toInt();
  }
}