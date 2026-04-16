import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

class CitizenUser {
  final String uid;
  final String name;
  final String email;
  final String wilaya;
  final int reports;
  final int resolved;
  final bool online;
  final Color color;
  final String initials;

  CitizenUser({
    this.uid = '',
    required this.name,
    required this.email,
    required this.wilaya,
    required this.reports,
    required this.resolved,
    required this.online,
    required this.color,
    required this.initials,
  });

  // Calculé automatiquement, pas besoin de le stocker
  int get resolutionRate {
    if (reports == 0) return 0;
    return ((resolved / reports) * 100).round();
  }

  // Créer depuis Firestore
  factory CitizenUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // ✅ Si pas de name → utilise la partie avant @ de l'email
    final String email = data['email'] ?? '';
    final String name = (data['name'] ?? '').toString().trim().isNotEmpty
        ? data['name'].toString().trim()
        : email.split('@')[0]; // ex: "xiao" depuis "xiao@gmail.com"

    return CitizenUser(
      uid: doc.id,
      name: name,
      email: email,
      wilaya: data['wilaya'] ?? '',
      reports: data['reports'] ?? 0,
      resolved: data['resolved'] ?? 0,
      online: data['online'] ?? false,
      color: _colorFromName(name),
      initials: _getInitials(name),
    );
  }

  // Sauvegarder dans Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'wilaya': wilaya,
      'reports': reports,
      'resolved': resolved,
      'online': online,
      // color et initials ne sont PAS stockés → générés automatiquement
    };
  }

  // "Rihab Benali" → "RB"
  static String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (name.length >= 2) return name.substring(0, 2).toUpperCase();
    return name.toUpperCase();
  }

  // Couleur stable basée sur le nom
  static Color _colorFromName(String name) {
    const colors = [
      Color(0xFF1565C0),
      Color(0xFF6A1B9A),
      Color(0xFF2E7D32),
      Color(0xFFC62828),
      Color(0xFFE65100),
      Color(0xFF00695C),
    ];
    if (name.isEmpty) return colors[0];
    return colors[name.codeUnitAt(0) % colors.length];
  }
}
