import 'dart:math';
import 'package:flutter/material.dart';
import '../models/report.dart';
import '../models/user.dart';
import '../models/alerts.dart';
import '../models/log.dart';

final _random = Random(); // fixed seed for consistent layout

int rnd(int min, int max) => min + _random.nextInt(max - min + 1);

T pick<T>(List<T> arr) => arr[_random.nextInt(arr.length)];

T weightedPick<T>(List<T> items, List<double> weights) {
  double total = weights.reduce((a, b) => a + b);
  double r = _random.nextDouble() * total;

  double s = 0.0;
  for (int i = 0; i < items.length; i++) {
    s += weights[i];
    if (r < s) return items[i];
  }
  return items.last;
}

const List<String> categories = [
  'roads',
  'water',
  'lighting',
  'waste',
  'parks',
  'other',
];
const Map<String, String> catIcons = {
  'roads': '🛣️',
  'water': '💧',
  'lighting': '💡',
  'waste': '🗑️',
  'parks': '🌳',
  'other': '📦',
};
const List<String> wilayas = [
  'Alger',
  'Oran',
  'Constantine',
  'Annaba',
  'Blida',
  'Tlemcen',
  'Sétif',
  'Béjaïa',
  'Médéa',
  'Biskra',
  'Batna',
  'Tizi Ouzou',
  'Jijel',
  'Skikda',
];
const List<String> statuses = ['pending', 'inprogress', 'resolved', 'rejected'];
const List<double> statusWeights = [0.15, 0.15, 0.65, 0.05];

List<Report> generateMockReports() {
  return List.generate(24, (i) {
    final d = DateTime.now().subtract(Duration(days: rnd(0, 365)));
    const List<String> monthStrs = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dateStr =
        '${d.day.toString().padLeft(2, '0')} ${monthStrs[d.month - 1]} ${d.year}';

    return Report(
      id: 'RPT-${(2800 - i).toString().padLeft(4, '0')}',
      category: pick(categories),
      desc: pick([
        'Pothole on main road',
        'Street lamp not working',
        'Water pipe leak',
        'Garbage overflow',
        'Tree fallen on sidewalk',
        'Cracked pavement',
        'Drainage blocked',
        'Broken bench',
      ]),
      address: '${pick(wilayas)}, Rue ${rnd(1, 200)}',
      status: weightedPick(statuses, statusWeights),
      confirmations: rnd(1, 47),
      date: dateStr,
    );
  });
}

class MockData {
  static List<Report> reports = generateMockReports();
  static List<CitizenUser> users = generateMockUsers();
  static List<AdminLog> logs = generateMockLogs();
}

final List<String> names = [
  'Rihab Benali',
  'Fatima Hadj',
  'Mohamed Cherif',
  'Amira Bouali',
  'Karim Meziane',
  'Nadia Beloufa',
];

final List<Color> avatarsColors = [
  const Color(0xFF1D4ED8),
  const Color(0xFF7C3AED),
  const Color(0xFF059669),
  const Color(0xFFDC2626),
  const Color(0xFFD97706),
  const Color(0xFF0891B2),
];

List<CitizenUser> generateMockUsers() {
  return List.generate(names.length, (i) {
    final n = names[i];
    return CitizenUser(
      name: n,
      email: '${n.toLowerCase().replaceAll(' ', '.')}@gmail.com',
      wilaya: pick(wilayas),
      reports: rnd(1, 24),
      resolved: rnd(0, 18),
      online: i < 4,
      color: avatarsColors[i % avatarsColors.length],
      initials: n.split(' ').map((w) => w[0]).join(''),
      uid: 'USR-${i + 1}',
    );
  });
}

final List<Alert> alertsList = [
  Alert(
    icon: '🚨',
    bg: const Color(0xFFFEE2E2),
    title: 'Urgent: Water Main Break',
    desc:
        'Report #RPT-2841 in Alger has received 34 confirmations. Immediate action required.',
    time: '2 minutes ago',
  ),
  Alert(
    icon: '⚠️',
    bg: const Color(0xFFFEF3C7),
    title: 'High-Volume Category: Roads',
    desc: 'Road reports increased by 40% in the last 24 hours in Oran wilaya.',
    time: '18 minutes ago',
  ),
  Alert(
    icon: '✅',
    bg: const Color(0xFFD1FAE5),
    title: 'Batch resolved — Lighting',
    desc:
        '47 street lighting reports in Constantine were marked as resolved by municipality.',
    time: '1 hour ago',
  ),
  Alert(
    icon: '👤',
    bg: const Color(0xFFDBEAFE),
    title: 'New citizen milestone',
    desc:
        'CityFix reached 14,000 registered users. Growth rate +22% this quarter.',
    time: '3 hours ago',
  ),
  Alert(
    icon: '📊',
    bg: const Color(0xFFF3E8FF),
    title: 'Weekly report digest ready',
    desc: 'Your weekly analytics summary for April 2024 is ready for download.',
    time: 'Yesterday 9:00 AM',
  ),
  Alert(
    icon: '🔒',
    bg: const Color(0xFFF8FAFF),
    title: 'Admin login from new device',
    desc: 'New login detected from IP 105.99.47.201 (Algiers, Algeria).',
    time: 'Yesterday 2:34 PM',
  ),
];

const List<String> logActions = [
  'Status updated',
  'Report deleted',
  'User suspended',
  'Export generated',
  'Settings changed',
  'Category edited',
  'Report viewed',
  'Login',
];

List<AdminLog> generateMockLogs() {
  return List.generate(20, (i) {
    final d = DateTime.now().subtract(Duration(minutes: i * rnd(10, 120)));
    final timeStr =
        '${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return AdminLog(
      time: timeStr,
      admin: 'Admin',
      action: pick(logActions),
      target: pick(MockData.reports).id,
      ip: '105.${rnd(1, 254)}.${rnd(1, 254)}.${rnd(1, 254)}',
    );
  });
}
