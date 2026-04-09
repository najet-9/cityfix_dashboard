import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AdminReportController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateReportStatus({
    required String docId,
    required String newStatus,
    required String currentStatus,
    required String userId,
  }) async {
    if (newStatus == currentStatus) return;
    if (userId.isEmpty) return;

    // 1. Update Firestore first (this always works on Web)
    await _db.collection('reports').doc(docId).update({'status': newStatus});

    String message = newStatus == 'in_progress'
        ? 'Your report is now being handled.'
        : 'Your reported issue has been resolved.';

    // 2. Add to notifications collection (this always works on Web)
    await _db.collection('notifications').add({
      'userId': userId,
      'message': message,
      'type': newStatus,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 3. OneSignal Call (This is where Web/CORS issues happen)
    /* try {
      final userDoc = await _db.collection('users').doc(userId).get();
      final String? oneSignalId = userDoc.data()?['oneSignalId'];
      final String? apiKey = dotenv.env['ONESIGNAL_API_KEY'];

      if (oneSignalId != null && apiKey != null) {
        final response = await http.post(
          Uri.parse('https://onesignal.com/api/v1/notifications'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Basic $apiKey',
          },
          body: jsonEncode({
            'app_id': 'a20c368d-e7a7-420b-8cdf-e6266b6e82ed',
            'include_subscription_ids': [oneSignalId],
            'contents': {'en': message},
          }),
        );
        debugPrint("OneSignal response: ${response.statusCode}");
      }
    } catch (e) {
      // This catch block prevents the "Platform Message" crash on Web
      debugPrint("PUSH NOTIFICATION ERROR (likely CORS on Web): $e");
    }*/
  }
}
