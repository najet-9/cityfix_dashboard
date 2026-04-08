import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Citizens",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "598 registered users across Algeria",
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.person_add_alt_1_rounded, size: 18, color: Colors.white),
                        label: const Text("Add User", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // GRILLE DES UTILISATEURS
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 1.6, 
                    children: [
                      _buildUserCard("Rihab Benali", "rihab.benali@gmail.com", "Jijel", "RB", const Color(0xFF1D4ED8), 3, 8, "267%"),
                      _buildUserCard("Fatima Hadj", "fatima.hadj@gmail.com", "Constantine", "FH", const Color(0xFF7C3AED), 5, 1, "20%"),
                      _buildUserCard("Mohamed Cherif", "mohamed.cherif@gmail.com", "Sétif", "MC", const Color(0xFF059669), 8, 5, "63%"),
                      _buildUserCard("Amira Bouali", "amira.bouali@gmail.com", "Tlemcen", "AB", const Color(0xFFDC2626), 22, 9, "41%"),
                      _buildUserCard("Karim Meziane", "karim.meziane@gmail.com", "Jijel", "KM", const Color(0xFFD97706), 16, 6, "38%"),
                      _buildUserCard("Nadia Beloufa", "nadia.beloufa@gmail.com", "Oran", "NB", const Color(0xFF0891B2), 21, 14, "67%"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Text("Citizen Users", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 16)),
          const Spacer(),
          Container(
            width: 350, height: 40,
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Search reports, users...",
                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                prefixIcon: Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 16),
          _buildIconButton(Icons.notifications_none_rounded, badge: "3"),
          const SizedBox(width: 8),
          _buildIconButton(Icons.file_download_outlined),
          const SizedBox(width: 8),
          _buildIconButton(Icons.refresh_rounded),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {String? badge}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 40, width: 40,
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: const Color(0xFF64748B)),
        ),
        if (badge != null)
          Positioned(
            right: -4, top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
              child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          )
      ],
    );
  }

  // --- USER CARD COMPONENT ---
  Widget _buildUserCard(String name, String email, String city, String initials, Color color, int reports, int resolved, String rate) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // Coins plus arrondis
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
                          child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
                        ),
                        Positioned(
                          right: 0, bottom: 0,
                          child: Container(
                            width: 14, height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981), // Point vert statut
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 18, color: const Color(0xFF0F172A))),
                          Text(email, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF2563EB)),
                      const SizedBox(width: 4),
                      Text(city, style: const TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // ZONE DES STATISTIQUES AVEC BORDURES POUR RÉDUIRE L'ESPACE
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                _buildStatMini(reports.toString(), "Reports"),
                _buildDivider(),
                _buildStatMini(resolved.toString(), "Resolved"),
                _buildDivider(),
                _buildStatMini(rate, "Rate"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 24, width: 1, color: const Color(0xFFF1F5F9));
  }

  Widget _buildStatMini(String val, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(val, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18, color: const Color(0xFF0F172A))),
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        ],
      ),
    );
  }
}