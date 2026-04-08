import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('reports')
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text("No reports found."));
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              horizontalMargin: 12,
                              columnSpacing: 24,
                              headingRowHeight: 48,
                              dataRowMaxHeight: 60,
                              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
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
                              rows: snapshot.data!.docs.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                
                                // جلب اسم الموقع كـ String
                                String locDisplay = data['locationName'] ?? data['address'] ?? "Unknown Location";

                                // جلب عدد التأكيدات الفعلي من Firestore
                                int confirmationCount = 0;
                                if (data['confirmations'] != null) {
                                  confirmationCount = (data['confirmations'] as num).toInt();
                                }

                                String dateFormatted = "---";
                                if (data['createdAt'] is Timestamp) {
                                  DateTime dt = (data['createdAt'] as Timestamp).toDate();
                                  dateFormatted = DateFormat('dd MMM yyyy').format(dt);
                                }

                                return _buildReportRow(
                                  data['reportId'] ?? doc.id.substring(0, 8).toUpperCase(),
                                  data['category'] ?? "Other",
                                  data['description'] ?? "",
                                  locDisplay,
                                  data['status'] ?? "Pending",
                                  confirmationCount,
                                  dateFormatted,
                                  doc.id,
                                );
                              }).toList(),
                            ),
                          );
                        },
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

  DataRow _buildReportRow(String id, String cat, String desc, String loc, String status, int confirms, String date, String docId) {
    Color themeColor = _getCategoryColor(cat);

    return DataRow(cells: [
      DataCell(Text(id, style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500))),
      DataCell(_buildCategoryBadge(cat, themeColor)),
      DataCell(Text(desc, style: GoogleFonts.plusJakartaSans(color: const Color(0xFF1E293B), fontSize: 13, fontWeight: FontWeight.w500))),
      DataCell(Text(loc, style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B), fontSize: 13))),
      // لون الحالة يتبع لون الفئة
      DataCell(_buildStatusBadge(status, themeColor)),
      DataCell(Row(
        children: [
          const Icon(Icons.thumb_up_alt_rounded, size: 16, color: Color(0xFFD97706)),
          const SizedBox(width: 8),
          // عرض عدد التأكيدات المتغير
          Text(confirms.toString(), style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: const Color(0xFF1E293B), fontSize: 13)),
        ],
      )),
      DataCell(Text(date, style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B), fontSize: 13))),
      DataCell(Row(
        children: [
          _buildActionIcon(Icons.visibility_outlined),
          const SizedBox(width: 8),
          _buildActionIcon(Icons.delete_outline_rounded, isDelete: true, docId: docId),
        ],
      )),
    ]);
  }

  Color _getCategoryColor(String label) {
    switch (label.toLowerCase()) {
      case "lighting": return Colors.amber;
      case "water": return Colors.blue;
      case "parks": return Colors.green;
      case "roads": return const Color(0xFF8B4513);
      default: return Colors.purple;
    }
  }
Widget _buildCategoryBadge(String label, Color color) {
    IconData icon;
    switch (label.toLowerCase()) {
      case "lighting": icon = Icons.wb_incandescent_outlined; break;
      case "water": icon = Icons.opacity_rounded; break;
      case "parks": icon = Icons.park_outlined; break;
      case "roads": icon = Icons.terrain_rounded; break;
      default: icon = Icons.category_outlined;
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
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.plusJakartaSans(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
      child: Row(
        children: [
          Text("All Reports", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 16)),
          const Spacer(),
          Container(
            width: 350,
            height: 40,
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Search reports, users...",
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
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {String? badge}) {
    return Stack(
      children: [
        Container(
          height: 40, width: 40,
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: const Color(0xFF64748B)),
        ),
        if (badge != null)
          Positioned(right: -2, top: -2, child: CircleAvatar(radius: 7, backgroundColor: Colors.red, child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 8)))),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, {bool isDelete = false, String? docId}) {
    return GestureDetector(
      onTap: () {
        if (isDelete && docId != null) FirebaseFirestore.instance.collection('reports').doc(docId).delete();
      },
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 16, color: isDelete ? Colors.red : const Color(0xFF64748B)),
      ),
    );
  }
}