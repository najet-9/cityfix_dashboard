import 'dart:ui';

class CitizenUser {
  final String name;
  final String email;
  final String wilaya;
  final int reports;
  final int resolved;
  final bool online;
  final Color color;
  final String initials;

  CitizenUser({
    required this.name,
    required this.email,
    required this.wilaya,
    required this.reports,
    required this.resolved,
    required this.online,
    required this.color,
    required this.initials,
  });
}
