import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add this to your pubspec.yaml for date formatting

class AdminAlerts extends StatelessWidget {
  const AdminAlerts({super.key});

  // Helper to convert the string colors from your Firestore logic into Flutter Colors
  Color _getBgColor(String? colorName) {
    switch (colorName) {
      case 'red':
        return const Color(0xFFFEE2E2);
      case 'blue':
        return const Color(0xFFDBEAFE);
      case 'green':
        return const Color(0xFFDCFCE7);
      case 'orange':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  Color _getIconColor(String? colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'blue':
        return const Color(0xFF1E40AF);
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange[700]!;
      default:
        return const Color(0xFF64748B);
    }
  }

  // Helper to map icon strings to IconData
  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'priority_high':
        return Icons.notifications_active_rounded;
      case 'person_add':
        return Icons.person_add_rounded;
      case 'assignment_turned_in':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkSidebar = Color(0xFF0F172A);
    const Color textGrey = Color(0xFF64748B);
    const Color cityfixBlue = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // --- 1. TOP BAR ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            color: Colors.white,
            child: Row(
              children: [
                const Text(
                  "Alerts",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkSidebar,
                  ),
                ),
                const Spacer(),
                _buildSearchBar(),
                const SizedBox(width: 15),
                _buildTopIcon(
                  Icons.notifications_none_rounded,
                  hasBadge: true,
                  badgeCount: "3",
                ),
                const SizedBox(width: 10),
                _buildTopIcon(Icons.file_download_outlined),
                const SizedBox(width: 10),
                _buildTopIcon(Icons.refresh_rounded),
              ],
            ),
          ),

          // --- 2. DYNAMIC CONTENT ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Alerts & Notifications",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: darkSidebar,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "System events and urgent reports",
                            style: TextStyle(color: textGrey, fontSize: 13),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Logic to mark all as read in Firestore
                          var snapshots = await FirebaseFirestore.instance
                              .collection('admin_alerts')
                              .where('isRead', isEqualTo: false)
                              .get();
                          for (var doc in snapshots.docs) {
                            doc.reference.update({'isRead': true});
                          }
                        },
                        icon: const Icon(
                          Icons.done_all_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Mark all read",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cityfixBlue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // STREAM BUILDER replaces the hardcoded list
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('admin_alerts')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No alerts found."));
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (context, index) => const Divider(
                            color: Color(0xFFF1F5F9),
                            height: 32,
                          ),
                          itemBuilder: (context, index) {
                            var alert =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            return _buildAlertRow(alert, darkSidebar, textGrey);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertRow(Map<String, dynamic> alert, Color dark, Color grey) {
    // Formatting the timestamp from Firestore
    String timeAgo = "Just now";
    if (alert['time'] != null) {
      DateTime dt = (alert['time'] as Timestamp).toDate();
      timeAgo = DateFormat('MMM d, h:mm a').format(dt);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getBgColor(alert['bgColor']),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getIconData(alert['icon']),
            color: _getIconColor(alert['bgColor']),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alert['title'] ?? 'Alert',
                style: TextStyle(
                  fontWeight: alert['isRead'] == false
                      ? FontWeight.w800
                      : FontWeight.w700,
                  fontSize: 15,
                  color: dark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                alert['desc'] ?? '',
                style: TextStyle(color: grey, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 6),
              Text(
                timeAgo,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Search and Icon widgets remain the same ---
  Widget _buildSearchBar() {
    /* ... unchanged ... */
    return Container();
  }

  Widget _buildTopIcon(
    IconData icon, {
    bool hasBadge = false,
    String? badgeCount,
  }) {
    /* ... unchanged ... */
    return Container();
  }
}
