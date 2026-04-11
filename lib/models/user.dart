import 'dart:ui';

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
    required this.uid,
    required this.name,
    required this.email,
    required this.wilaya,
    required this.reports,
    required this.resolved,
    required this.online,
    required this.color,
    required this.initials,
  });
  //  Convert Firestore → Object
  factory CitizenUser.fromMap(Map<String, dynamic> data) {
    // Cherche fullName en priorité, puis name
    final name = (data['fullName'] ?? data['name'] ?? '').toString().trim();

    return CitizenUser(
      uid: data['uid'] ?? '',
      name: name.isEmpty ? 'Iconnu' : name,
      email: data['email'] ?? '',
      wilaya: data['city'] ?? '',
      reports: data['reports'] ?? 0,
      resolved: data['resolved'] ?? 0,
      online: data['online'] ?? false,

      // UI auto généré
      color: _generateColor(name),
      initials: _getInitials(name),
    );
  }

  //  Générer couleur automatiquement
  static Color _generateColor(String name) {
    final colors = [
      Color(0xFF4A90E2),
      Color(0xFF7B61FF),
      Color(0xFF2ECC71),
      Color(0xFFE67E22),
      Color(0xFFE74C3C),
    ];
    if (name.isEmpty) return colors[0];
    return colors[name.hashCode.abs() % colors.length];
  }

  //  Initiales
  static String _getInitials(String name) {
    // Vérification que le mot n'est pas vide avant
    List<String> parts = name
        .trim()
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }
}
