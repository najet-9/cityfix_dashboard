import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAlerts extends StatelessWidget {
  const AdminAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkSidebar = Color(0xFF0F172A);
    const Color textGrey = Color(0xFF64748B);
    const Color cityfixBlue = Color(0xFF2563EB);

    final List<Map<String, dynamic>> alerts = [
      {
        "title": "Urgent: Water Main Break",
        "desc": "Report #RPT-2841 in Alger has received 34 confirmations. Immediate action required.",
        "time": "2 minutes ago",
        "icon": Icons.notifications_active_rounded,
        "bgColor": const Color(0xFFFEE2E2),
        "iconColor": Colors.red,
      },
      {
        "title": "High-Volume Category: Roads",
        "desc": "Road reports increased by 40% in the last 24 hours in Oran wilaya.",
        "time": "18 minutes ago",
        "icon": Icons.warning_amber_rounded,
        "bgColor": const Color(0xFFFEF3C7),
        "iconColor": Colors.amber[700],
      },
      {
        "title": "Batch resolved — Lighting",
        "desc": "47 street lighting reports in Constantine were marked as resolved by municipality.",
        "time": "1 hour ago",
        "icon": Icons.check_circle_outline_rounded,
        "bgColor": const Color(0xFFDCFCE7),
        "iconColor": Colors.green,
      },
      {
        "title": "New citizen milestone",
        "desc": "CityFix reached 14,000 registered users. Growth rate +22% this quarter.",
        "time": "3 hours ago",
        "icon": Icons.person_rounded,
        "bgColor": const Color(0xFFDBEAFE),
        "iconColor": const Color(0xFF1E40AF),
      },
      {
        "title": "Weekly report digest ready",
        "desc": "Your weekly analytics summary for April 2024 is ready for download.",
        "time": "Yesterday 9:00 AM",
        "icon": Icons.bar_chart_rounded,
        "bgColor": const Color(0xFFF3E8FF),
        "iconColor": Colors.purple,
      },
      {
        "title": "Admin login from new device",
        "desc": "New login detected from IP 105.99.47.201 (Algiers, Algeria).",
        "time": "Yesterday 2:34 PM",
        "icon": Icons.lock_outline_rounded,
        "bgColor": const Color(0xFFF1F5F9),
        "iconColor": Colors.orange,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // --- 1. TOP BAR (Barre de recherche et icônes) ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            color: Colors.white,
            child: Row(
              children: [
                const Text("Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkSidebar)),
                const Spacer(),
                // Barre de recherche
                _buildSearchBar(),
                const SizedBox(width: 15),
                _buildTopIcon(Icons.notifications_none_rounded, hasBadge: true, badgeCount: "3"),
                const SizedBox(width: 10),
                _buildTopIcon(Icons.file_download_outlined),
                const SizedBox(width: 10),
                _buildTopIcon(Icons.refresh_rounded),
              ],
            ),
          ),

          // --- 2. CONTENU DE LA PAGE ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header avec Titre et Bouton alignés
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Alerts & Notifications", 
                            style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: darkSidebar)),
                          const SizedBox(height: 4),
                          const Text("System events and urgent reports", 
                            style: TextStyle(color: textGrey, fontSize: 13)),
                        ],
                      ),
                      // Bouton Mark all read avec texte blanc
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.done_all_rounded, size: 16, color: Colors.white),
                        label: const Text("Mark all read", 
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cityfixBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Liste des alertes
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: alerts.length,
                      separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 32),
                      itemBuilder: (context, index) {
                        final alert = alerts[index];
                        return _buildAlertRow(alert, darkSidebar, textGrey);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour la barre de recherche du haut
  Widget _buildSearchBar() {
    return Container(
      width: 250,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search reports, users...",
          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          prefixIcon: Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  // Widget pour les icônes du haut
  Widget _buildTopIcon(IconData icon, {bool hasBadge = false, String? badgeCount}) {
    return Stack(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF64748B)),
        ),
        if (hasBadge)
          Positioned(
            right: 5,
            top: 5,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: Text(badgeCount!, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
          ),
      ],
    );
  }

  // Widget pour chaque ligne d'alerte
  Widget _buildAlertRow(Map<String, dynamic> alert, Color dark, Color grey) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: alert['bgColor'], borderRadius: BorderRadius.circular(10)),
          child: Icon(alert['icon'], color: alert['iconColor'], size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(alert['title'], style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: dark)),
              const SizedBox(height: 2),
              Text(alert['desc'], style: TextStyle(color: grey, fontSize: 13, height: 1.4)),
              const SizedBox(height: 6),
              Text(alert['time'], style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}