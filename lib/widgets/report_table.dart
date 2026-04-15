import 'package:admin_dashboard/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/report.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import 'package:admin_dashboard/models/report_model.dart';

class ReportTable extends StatelessWidget {
  final List<ReportModel> reports;

  const ReportTable({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.transparent),
        dataRowMaxHeight: double.infinity,
        dataRowMinHeight: 60,
        dividerThickness: 1,
        columnSpacing: 24,
        columns: const [
          DataColumn(label: _TableHeading('ID')),
          DataColumn(label: _TableHeading('Category')),
          DataColumn(label: _TableHeading('Description')),
          DataColumn(label: _TableHeading('Location')),
          DataColumn(label: _TableHeading('Status')),
          DataColumn(label: _TableHeading('Confirmations')),
          DataColumn(label: _TableHeading('Date')),
        ],
        rows: reports.map((r) {
          return DataRow(
            cells: [
              DataCell(Text(r.reportId ??'', style: const TextStyle(fontFamily: 'JetBrains Mono', color: AppTheme.textMuted, fontSize: 12))),
              DataCell(_buildCatBadge(r.category)),
              DataCell(Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(r.description, maxLines: 1, overflow: TextOverflow.ellipsis),
              )),
              DataCell(Text(r.address ??'', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))),
              DataCell(_buildStatusBadge(r.status)),
              DataCell(Text('👍 ${r.confirmationCount}', style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary))),
              DataCell(Text(r.createdAt?.toDate().toString() ??'', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCatBadge(String cat) {
    final colors = {
      'roads': const Color(0xFFFEF3C7),
      'water': const Color(0xFFDBEAFE),
      'lighting': const Color(0xFFFEF9C3),
      'waste': const Color(0xFFD1FAE5),
      'parks': const Color(0xFFFCE7F3),
      'other': const Color(0xFFF3E8FF),
    };
    final textColors = {
      'roads': const Color(0xFF92400E),
      'water': const Color(0xFF1E40AF),
      'lighting': const Color(0xFF713F12),
      'waste': const Color(0xFF065F46),
      'parks': const Color(0xFF9D174D),
      'other': const Color(0xFF6B21A8),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors[cat] ?? colors['other'],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(catIcons[cat] ?? '📦', style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          Text(
            cat[0].toUpperCase() + cat.substring(1),
            style: TextStyle(color: textColors[cat] ?? textColors['other'], fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final labels = {'pending': 'Pending', 'inprogress': 'In Progress', 'resolved': 'Resolved', 'rejected': 'Rejected'};
    final bg = {
      'pending': const Color(0xFFFEF3C7),
      'inprogress': const Color(0xFFDBEAFE),
      'resolved': const Color(0xFFD1FAE5),
      'rejected': const Color(0xFFFEE2E2),
    };
    final color = {
      'pending': const Color(0xFF92400E),
      'inprogress': const Color(0xFF1E40AF),
      'resolved': const Color(0xFF065F46),
      'rejected': const Color(0xFF991B1B),
    };
    final dotColor = {
      'pending': AppTheme.accent,
      'inprogress': AppTheme.primary,
      'resolved': AppTheme.accent2,
      'rejected': AppTheme.danger,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg[status] ?? bg['pending'],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6, height: 6,
            decoration: BoxDecoration(color: dotColor[status] ?? dotColor['pending'], shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            labels[status] ?? status,
            style: TextStyle(color: color[status] ?? color['pending'], fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(dynamic icon, {bool isDanger = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border, width: 1.5),
        ),
        alignment: Alignment.center,
        child: FaIcon(icon, size: 13, color: isDanger ? AppTheme.danger : AppTheme.textMuted),
      ),
    );
  }
}

class _TableHeading extends StatelessWidget {
  final String text;
  const _TableHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppTheme.textMuted,
        fontWeight: FontWeight.w600,
        fontSize: 12,
        letterSpacing: 0.5,
      ),
    );
  }
}
