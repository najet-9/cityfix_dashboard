import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatCard extends StatefulWidget {
  final Widget icon;
  final Color iconBg;
  final Color gradientStart;
  final Color gradientEnd;
  final String trend;
  final bool isUp;
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.gradientStart,
    required this.gradientEnd,
    required this.trend,
    required this.isUp,
    required this.value,
    required this.label,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: AppTheme.border),
          boxShadow: _isHovered
              ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.13), blurRadius: 40, offset: const Offset(0, 8))]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: widget.iconBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: widget.icon,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.isUp ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(widget.isUp ? Icons.trending_up : Icons.trending_down, size: 12, color: widget.isUp ? const Color(0xFF059669) : const Color(0xFFDC2626)),
                              const SizedBox(width: 4),
                              Text(widget.trend, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: widget.isUp ? const Color(0xFF059669) : const Color(0xFFDC2626))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.value,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.text, letterSpacing: -1.5, height: 1),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.label,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [widget.gradientStart, widget.gradientEnd], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
