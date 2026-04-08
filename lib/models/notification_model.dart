import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? notificationId;
  String userId;
  String? reportId;
  String message;
  Timestamp? createdAt;
  bool isRead;
  String type; 

  NotificationModel({
    this.notificationId,
    required this.userId,
    this.reportId,
    required this.message,
    this.createdAt,
    this.isRead = false,
    required this.type,
  });
  //to store in firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'reportId': reportId,
      'message': message,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': isRead,
      'type': type,
    };
  }

  //to fetch from firestore
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return NotificationModel(
      notificationId: doc.id,
      userId: data['userId'] ?? '',
      reportId: data['reportId'] ?? '',
      message: data['message'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
      isRead: data['isRead'] ?? false,
      type: data['type'] ?? 'general',
    );
  }
}
