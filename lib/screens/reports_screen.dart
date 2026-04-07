import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

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
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "All Reports",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        horizontalMargin: 12,
                        columnSpacing: 24,
                        headingRowHeight: 48,
                        dataRowMaxHeight: 60,
                        headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
                        dividerThickness: 1,
                        headingTextStyle: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                        columns: const [
                          DataColumn(label: Text("ID")),
                          DataColumn(label: Text("CATEGORY")),
                          DataColumn(label: Text("DESCRIPTION")),
                          DataColumn(label: Text("LOCATION")),
                          DataColumn(label: Text("STATUS")),
                          DataColumn(label: Text("CONFIRMATIONS")),
                          DataColumn(label: Text("DATE")),
                          DataColumn(label: Text("ACTIONS")),
                        ],
                        rows: [
                          _buildReportRow("RPT-2791", "Lighting", "Garbage overflow", "Tlemcen, Rue 113", "Pending", Colors.orange, 36, "09 May 2026"),
                          _buildReportRow("RPT-2790", "Water", "Garbage overflow", "Tizi Ouzou, Rue 157", "In Progress", Colors.blue, 22, "05 Sept 2026"),
                          _buildReportRow("RPT-2789", "Parks", "Drainage blocked", "Béjaïa, Rue 5", "Resolved", Colors.green, 13, "11 Mar 2026"),
                          _buildReportRow("RPT-2788", "Roads", "Pothole on main road", "Biskra, Rue 157", "In Progress", Colors.blue, 18, "23 May 2026"),
                          _buildReportRow("RPT-2787", "Parks", "Broken bench", "Tizi Ouzou, Rue 57", "Resolved", Colors.green, 12, "20 Oct 2026"),
                          _buildReportRow("RPT-2786", "Parks", "Pothole on main road", "Béjaïa, Rue 167", "Resolved", Colors.green, 45, "06 Mar 2026"),
                          _buildReportRow("RPT-2785", "Roads", "Cracked pavement", "Constantine, Rue 171", "Pending", Colors.orange, 19, "12 Jun 2026"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TOP BAR ---
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Text("All Reports", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 16)),
          const Spacer(),
          Container(
            width: 350,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
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
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF64748B)),
        ),
        if (badge != null)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
              child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          )
      ],
    );
  }

  // --- DATA TABLE COMPONENTS ---
  DataRow _buildReportRow(String id, String cat, String desc, String loc, String status, Color color, int confirms, String date) {
    return DataRow(cells: [
      DataCell(Text(id, style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500))),
      DataCell(_buildCategoryBadge(cat)),
      DataCell(Text(desc, style: GoogleFonts.plusJakartaSans(color: const Color(0xFF1E293B), fontSize: 13, fontWeight: FontWeight.w500))),
      DataCell(Text(loc, style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B), fontSize: 13))),
      DataCell(_buildStatusBadge(status, color)),
      DataCell(Row(
        children: [
          const Text("👍", style: TextStyle(fontSize: 14)), 
          const SizedBox(width: 6),
          Text(confirms.toString(), style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: const Color(0xFF1E293B), fontSize: 13)),
        ],
      )),
      DataCell(Text(date, style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B), fontSize: 13))),
      DataCell(Row(
        children: [
          _buildActionIcon(Icons.visibility_outlined),
          const SizedBox(width: 8),
          _buildActionIcon(Icons.edit_outlined),
          const SizedBox(width: 8),
          _buildActionIcon(Icons.delete_outline_rounded, isDelete: true),
        ],
      )),
    ]);
  }

  Widget _buildCategoryBadge(String label) {
    Color color;
    IconData icon;
    switch (label) {
      case "Lighting": color = Colors.amber; icon = Icons.wb_incandescent_outlined; break;
      case "Water": color = Colors.blue; icon = Icons.opacity_rounded; break;
      case "Parks": color = Colors.green; icon = Icons.park_outlined; break;
      case "Roads": color = Colors.brown; icon = Icons.terrain_rounded; break;
      default: color = Colors.purple; icon = Icons.category_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.plusJakartaSans(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.plusJakartaSans(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, {bool isDelete = false}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: isDelete ? Colors.red : const Color(0xFF64748B)),
    );
  }
}