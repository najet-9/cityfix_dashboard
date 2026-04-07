import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String? reportId;
  final String userId;
  final String category;
  final String imageUrl;
  final String description;
  final GeoPoint location;
  final String status;
  final int confirmationCount;
  final Timestamp? createdAt;
  final String? address;

  ReportModel({
    this.reportId,
    required this.userId,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.location,
    this.status = "pending",
    this.confirmationCount = 0,
    this.createdAt,
    this.address,
  });

  //  Convert Firestore → Object
  factory ReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ReportModel(
      reportId: doc.id,
      userId: data['userId'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? GeoPoint(0, 0),
      status: data['status'] ?? 'pending',
      confirmationCount: data['confirmationCount'] ?? 0,
      createdAt: data['createdAt'] as Timestamp?,
      address: data['address'] ?? '',
    );
  }

  //  Convert Object → Firestore (R)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
      'location': location,
      'status': status,
      'confirmationCount': confirmationCount,
      'createdAt': FieldValue.serverTimestamp(),
      'address': address,
    };
  }

  //  Helpers pour MAP
  double get latitude => location.latitude;
  double get longitude => location.longitude;
}
