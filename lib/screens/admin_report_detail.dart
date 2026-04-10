import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_dashboard/controllers/report_controller.dart';

// CHANGED: StatelessWidget → StatefulWidget so we can hold a controller instance.
// A StatelessWidget has no mutable state — it can't own an object like AdminReportController
// that might trigger rebuilds or async calls tied to the widget's lifecycle.
class AdminReportDetailScreen extends StatefulWidget {
  final Map<String, dynamic> report;

  const AdminReportDetailScreen({super.key, required this.report});

  @override
  State<AdminReportDetailScreen> createState() =>
      _AdminReportDetailScreenState();
}

class _AdminReportDetailScreenState extends State<AdminReportDetailScreen> {
  // Instantiated here, exactly like ReportsScreen does it.
  // This is the single source of truth for status-update logic in this screen.
  final AdminReportController _controller = AdminReportController();

  @override
  Widget build(BuildContext context) {
    // CHANGED: all 'report[...]' → 'widget.report[...]'
    // Inside a State class, the widget's properties live on 'widget', not 'this'.
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Report Details",
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: ORIGINAL REPORT ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.report['imageUrl'] ?? '',
                    width: 400,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 400,
                      height: 300,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoTile(
                        "Category",
                        widget.report['category'] ?? "General",
                      ),
                      _infoTile(
                        "Status",
                        widget.report['status']?.toString().toUpperCase() ??
                            "PENDING",
                      ),
                      _infoTile(
                        "Description",
                        widget.report['description'] ??
                            "No description provided.",
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _statusButton(context, "in_progress", Colors.blue),
                          const SizedBox(width: 10),
                          _statusButton(context, "resolved", Colors.green),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            Text(
              "Confirmations from Citizens",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Divider(height: 32),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reports')
                  .doc(widget.report['id']) // CHANGED: widget.report
                  .collection('confirmations')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("No citizen confirmations yet."),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    var conf =
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              conf['confirmationImg'] ?? '',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  conf['description'] ?? "No text provided",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Confirmed: ${conf['createdAt']?.toDate().toString().substring(0, 16) ?? ''}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // CHANGED: entire onPressed replaced — no longer calls Firestore directly.
  // Now goes through _controller.updateReportStatus(), which handles both
  // the status update AND the notification write atomically.
  Widget _statusButton(BuildContext context, String status, Color color) {
    return ElevatedButton(
      onPressed: () async {
        // Pull the values we need from the report map
        final String currentStatus = widget.report['status'] ?? 'pending';
        final String userId = widget.report['userId'] ?? '';
        final String docId = widget.report['id'];

        try {
          await _controller.updateReportStatus(
            docId: docId,
            newStatus: status,
            currentStatus: currentStatus,
            // controller will return early (no-op) if status didn't change
            userId: userId,
          );

          // Only runs if the await above completed without throwing
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Status updated to "$status"'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            // Pop only after confirmed success, not before
            Navigator.pop(context);
          }
        } catch (e) {
          // If Firestore or the notification write fails, stay on the screen
          // and show the error so the admin knows what went wrong
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(
        "Set to $status",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  // --- Helpers unchanged ---
  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
