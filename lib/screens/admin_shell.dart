import 'package:admin_dashboard/screens/admin_alerts.dart';
import 'package:admin_dashboard/controllers/auth_controller.dart';
import 'package:admin_dashboard/screens/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_dashboard/screens/overview_page.dart';
import 'package:admin_dashboard/screens/reports_screen.dart';
import 'package:admin_dashboard/screens/Users_screen.dart';
import 'package:admin_dashboard/screens/category_page.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final AdminAuthController _authController = AdminAuthController();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const OverviewPage(),
    const ReportsScreen(),
    const UsersScreen(),
    const AdminAlerts(),

    CategoryPage(),

    const Center(
      child: Text("Categories Page", style: TextStyle(fontSize: 24)),
    ),
    const Center(child: Text("Settings Page", style: TextStyle(fontSize: 24))),
    const Center(
      child: Text("Activity Logs Page", style: TextStyle(fontSize: 24)),
    ),
  ];

  Future<void> _signOut() async {
    await _authController.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CityFixSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            onSignOut: _signOut,
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF8FAFC),
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

class CityFixSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onSignOut;

  const CityFixSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    const Color sidebarBg = Color(0xFF0F172A);
    return Container(
      width: 260,
      color: sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _buildLogo(),
          const SizedBox(height: 40),
          _buildSectionHeader("OVERVIEW"),
          _buildMenuItem(
            0,
            Icons.grid_view_rounded,
            "Dashboard",
            isSelected: selectedIndex == 0,
          ),
          _buildMenuItem(
            1,
            Icons.flag_rounded,
            "Reports",
            isSelected: selectedIndex == 1,
            badge: "24",
          ),

          const SizedBox(height: 24),
          _buildSectionHeader("MANAGEMENT"),
          _buildMenuItem(
            2,
            Icons.people_alt_rounded,
            "Users",
            isSelected: selectedIndex == 2,
          ),
          _buildMenuItem(
            3,
            Icons.notifications_rounded,
            "Alerts",
            isSelected: selectedIndex == 3,
            badge: "3",
          ),
          _buildMenuItem(
            4,
            Icons.local_offer_rounded,
            "Categories",
            isSelected: selectedIndex == 4,
          ),

          const SizedBox(height: 24),
          _buildSectionHeader("SYSTEM"),
          _buildMenuItem(
            5,
            Icons.settings_rounded,
            "Settings",
            isSelected: selectedIndex == 5,
          ),
          _buildMenuItem(
            6,
            Icons.terminal_rounded,
            "Activity Logs",
            isSelected: selectedIndex == 6,
          ),
          const Spacer(),
          _buildAdminProfile(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_city_rounded,
              color: Colors.blueAccent,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CityFix",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "ADMIN CONSOLE",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white24,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    int index,
    IconData icon,
    String label, {
    required bool isSelected,
    String? badge,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => onItemSelected(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2563EB)
                : Colors.transparent, // Bleu électrique

            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white60,
                size: 22,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminProfile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "A",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Admin User",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Super Administrator",
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white38,
              size: 20,
            ),
            onPressed: onSignOut,
            tooltip: 'Sign out',
          ),
        ],
      ),
    );
  }
}
