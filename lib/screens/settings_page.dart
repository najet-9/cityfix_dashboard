import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(Theme.of(context).textTheme),
      ),
      child: Column(
        children: [
          _buildTopBar('Settings'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Settings', style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.text, letterSpacing: -0.5)),
                          const SizedBox(height: 3),
                          Text('Configure the CityFix admin console', style: GoogleFonts.plusJakartaSans(color: AppTheme.textMuted, fontSize: 13)),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.floppyDisk, size: 13, color: Colors.white),
                        label: Text('Save Changes', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 4,
                          shadowColor: AppTheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildSettingsSection(
                          title: 'Notifications',
                          icon: FontAwesomeIcons.bell,
                          tiles: [
                            const _SettingTile(label: 'New report alerts', sub: 'Get notified when a report is submitted', value: true),
                            const _SettingTile(label: 'High-confirmation alerts', sub: 'Alert when a report exceeds 10 confirmations', value: true),
                            const _SettingTile(label: 'Weekly digest', sub: 'Receive a weekly summary email', value: false),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildSettingsSection(
                          title: 'Localization',
                          icon: FontAwesomeIcons.globe,
                          tiles: [
                            const _SettingTile(label: 'Arabic language support', sub: 'Enable RTL layout for Arabic users', value: true),
                            const _SettingTile(label: 'French translation', sub: 'Display UI in French', value: true),
                          ],
                        ),
                      ),
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

  Widget _buildSettingsSection({required String title, required dynamic icon, required List<Widget> tiles}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 14),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppTheme.border))),
            child: Row(
              children: [
                FaIcon(icon, color: AppTheme.primary, size: 16),
                const SizedBox(width: 10),
                Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.text)),
              ],
            ),
          ),
          ...tiles,
        ],
      ),
    );
  }

  Widget _buildTopBar(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Text(title, 
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 16, color: AppTheme.text)),
          const Spacer(),
          Container(
            width: 350,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search user, configs...",
                hintStyle: GoogleFonts.plusJakartaSans(color: const Color(0xFF94A3B8), fontSize: 14),
                prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
              child: Text(badge, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          )
      ],
    );
  }
}

class _SettingTile extends StatefulWidget {
  final String label;
  final String sub;
  final bool value;
  const _SettingTile({required this.label, required this.sub, required this.value});

  @override
  State<_SettingTile> createState() => _SettingTileState();
}

class _SettingTileState extends State<_SettingTile> {
  late bool _val;

  @override
  void initState() {
    super.initState();
    _val = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppTheme.border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.text)),
                const SizedBox(height: 2),
                Text(widget.sub, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textMuted)),
              ],
            ),
          ),
          Switch(
            value: _val,
            onChanged: (v) => setState(() => _val = v),
            activeThumbColor: Colors.white,
            activeTrackColor: AppTheme.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppTheme.border,
          ),
        ],
      ),
    );
  }
}

