import 'package:admin_dashboard/controllers/overView_controller.dart';
import 'package:admin_dashboard/controllers/report_controller.dart';
import 'package:admin_dashboard/screens/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:admin_dashboard/theme/app_theme.dart';
import 'package:admin_dashboard/widgets/stat_card.dart';
import 'package:admin_dashboard/widgets/report_table.dart';
import 'package:admin_dashboard/models/dashboard_stats_model.dart';
import 'package:admin_dashboard/models/report_model.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});
  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Future<List<ReportModel>> reportsFuture;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(_pulseController);
    reportsFuture = AdminReportController().getRecentReports();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good morning, Admin 👋',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.text,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              FadeTransition(
                                opacity: _pulseAnimation,
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.accent2,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const Text(
                                'Live data · Last updated just now',
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ReportsScreen(),
                            ),
                          );
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.fileExport,
                          size: 13,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Export Report',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          shadowColor: AppTheme.primary.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Stats Cards ──
                  Consumer<DashboardController>(
                    builder: (context, controller, _) {
                      if (controller.isLoading) {
                        return const SizedBox(
                          height: 175,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (controller.errorMessage != null) {
                        return SizedBox(
                          height: 175,
                          child: Center(
                            child: Text(
                              controller.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }

                      final DashboardStatsModel s = controller.stats!;

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount =
                              MediaQuery.of(context).size.width > 1200 ? 4 : 2;
                          final itemWidth =
                              (constraints.maxWidth -
                                  (crossAxisCount - 1) * 20) /
                              crossAxisCount;
                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: itemWidth / 175.0,
                            children: [
                              StatCard(
                                icon: const FaIcon(
                                  FontAwesomeIcons.flag,
                                  color: AppTheme.primary,
                                  size: 18,
                                ),
                                iconBg: AppTheme.primaryLighter,
                                gradientStart: AppTheme.primary,
                                gradientEnd: AppTheme.primaryLight,
                                value: s.totalReports.toString(),
                                label: 'Total Reports',
                              ),
                              StatCard(
                                icon: const FaIcon(
                                  FontAwesomeIcons.circleCheck,
                                  color: Color(0xFF059669),
                                  size: 18,
                                ),
                                iconBg: const Color(0xFFD1FAE5),
                                gradientStart: const Color(0xFF059669),
                                gradientEnd: AppTheme.accent2,
                                value: s.resolved.toString(),
                                label: 'Resolved',
                              ),
                              StatCard(
                                icon: const FaIcon(
                                  FontAwesomeIcons.clock,
                                  color: Color(0xFFD97706),
                                  size: 18,
                                ),
                                iconBg: const Color(0xFFFEF3C7),
                                gradientStart: const Color(0xFFD97706),
                                gradientEnd: AppTheme.accent,
                                value: s.pending.toString(),
                                label: 'Pending',
                              ),
                              StatCard(
                                icon: const FaIcon(
                                  FontAwesomeIcons.users,
                                  color: Color(0xFFDC2626),
                                  size: 18,
                                ),
                                iconBg: const Color(0xFFFEE2E2),
                                gradientStart: const Color(0xFFDC2626),
                                gradientEnd: AppTheme.danger,
                                value: s.activeCitizens.toString(),
                                label: 'Active Citizens',
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // ── Charts Row ──
                  Consumer<DashboardController>(
                    builder: (context, controller, _) {
                      final s = controller.stats;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Graphe ligne ──
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radius,
                                ),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Reports Over Time',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.text,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              'Monthly report submissions — 2026',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppTheme.border,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            '2026',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.textMuted,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      24, 0, 24, 24,
                                    ),
                                    child: SizedBox(
                                      height: 250,
                                      child: _buildLineChart(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),

                          // ── Donut chart ──
                          Container(
                            width: 380,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radius),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'By Category',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.text,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Distribution of report types',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 180,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Donut avec données réelles si disponibles
                                      s != null
                                          ? _buildDonutChart(s)
                                          : const CircularProgressIndicator(),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            s != null
                                                ? s.totalReports.toString()
                                                : '0',
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w800,
                                              color: AppTheme.text,
                                              letterSpacing: -1,
                                            ),
                                          ),
                                          const Text(
                                            'Total',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: AppTheme.textMuted,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (s != null)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      24, 0, 24, 20,
                                    ),
                                    child: Column(
                                      children: [
                                        _buildLegendItem(
                                          'Roads',
                                          s.roads,
                                          const Color(0xFF1D4ED8),
                                          s.totalReports > 0
                                              ? s.roads / s.totalReports
                                              : 0,
                                        ),
                                        _buildLegendItem(
                                          'Lighting',
                                          s.lighting,
                                          const Color(0xFFF59E0B),
                                          s.totalReports > 0
                                              ? s.lighting / s.totalReports
                                              : 0,
                                        ),
                                        _buildLegendItem(
                                          'Water',
                                          s.water,
                                          const Color(0xFF10B981),
                                          s.totalReports > 0
                                              ? s.water / s.totalReports
                                              : 0,
                                        ),
                                        _buildLegendItem(
                                          'Waste',
                                          s.waste,
                                          const Color(0xFFEF4444),
                                          s.totalReports > 0
                                              ? s.waste / s.totalReports
                                              : 0,
                                        ),
                                        _buildLegendItem(
                                          'Parks',
                                          s.parks,
                                          const Color(0xFFF0C631),
                                          s.totalReports > 0
                                              ? s.parks / s.totalReports
                                              : 0,
                                        ),
                                        _buildLegendItem(
                                          'Other',
                                          s.other,
                                          const Color(0xFF8B5CF6),
                                          s.totalReports > 0
                                              ? s.other / s.totalReports
                                              : 0,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // ── Recent Reports Table ──
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.radius),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recent Reports',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.text,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Latest citizen-submitted issues',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const ReportsScreen(),
                                    ),
                                  );
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.arrowRight,
                                  size: 12,
                                ),
                                label: const Text(
                                  'View all',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder<List<ReportModel>>(
                          future: reportsFuture,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final reports = snapshot.data!.take(3).toList();
                            return ReportTable(reports: reports);
                          },
                        ),
                      ],
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

  // ── TOP BAR ──
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Text(
            "Dashboard Overview",
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppTheme.text,
            ),
          ),
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
                hintText: "Search analytics, reports...",
                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: Color(0xFF64748B),
                ),
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
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ── LEGEND ITEM ──
  Widget _buildLegendItem(
    String name,
    int count,
    Color color,
    double percent,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: percent,
                      backgroundColor: AppTheme.border,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 4,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 30,
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.text,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── LINE CHART ──
  Widget _buildLineChart() {
    return Consumer<DashboardController>(
      builder: (context, controller, _) {
        if (controller.isLoadingChart) {
          return const Center(child: CircularProgressIndicator());
        }

        List<FlSpot> reportSpots = [];
        List<FlSpot> resolvedSpots = [];

        for (int i = 1; i <= 12; i++) {
          reportSpots.add(FlSpot(
            (i - 1).toDouble(),
            (controller.monthlyReports[i] ?? 0).toDouble(),
          ));
          resolvedSpots.add(FlSpot(
            (i - 1).toDouble(),
            (controller.monthlyResolved[i] ?? 0).toDouble(),
          ));
        }

        return LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 100,
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: AppTheme.border, strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    const months = [
                      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                    ];
                    if (value.toInt() >= 0 && value.toInt() < 12) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          months[value.toInt()],
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 12,
                    ),
                  ),
                  reservedSize: 40,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: reportSpots,
                isCurved: true,
                color: const Color(0xFF1D4ED8),
                barWidth: 2.5,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xFF1D4ED8).withOpacity(0.07),
                ),
              ),
              LineChartBarData(
                spots: resolvedSpots,
                isCurved: true,
                color: const Color(0xFF10B981),
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xFF10B981).withOpacity(0.05),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── DONUT CHART ──
  Widget _buildDonutChart(DashboardStatsModel s) {
    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 65,
        sections: [
          PieChartSectionData(
            color: const Color(0xFF1D4ED8),
            value: s.roads.toDouble(),
            radius: 25,
            showTitle: false,
          ),
          PieChartSectionData(
            color: const Color(0xFFF59E0B),
            value: s.lighting.toDouble(),
            radius: 25,
            showTitle: false,
          ),
          PieChartSectionData(
            color: const Color(0xFF10B981),
            value: s.water.toDouble(),
            radius: 25,
            showTitle: false,
          ),
          PieChartSectionData(
            color: const Color(0xFFEF4444),
            value: s.waste.toDouble(),
            radius: 25,
            showTitle: false,
          ),
          PieChartSectionData(
            color: const Color(0xFFF0C631),
            value: s.parks.toDouble(),
            radius: 25,
            showTitle: false,
          ),
          PieChartSectionData(
            color: const Color(0xFF8B5CF6),
            value: s.other.toDouble(),
            radius: 25,
            showTitle: false,
          ),
        ],
      ),
    );
  }
}