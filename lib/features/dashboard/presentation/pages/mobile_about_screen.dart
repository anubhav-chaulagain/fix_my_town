// mobile_about_screen.dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MobileAboutScreen extends StatefulWidget {
  const MobileAboutScreen({super.key});

  @override
  State<MobileAboutScreen> createState() => _MobileAboutScreenState();
}

class _MobileAboutScreenState extends State<MobileAboutScreen> {
  static const primary = Color(0xFF1EA095);

  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      setState(() => _packageInfo = info);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // App icon + name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.location_city_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Fix My Town',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _packageInfo != null
                        ? 'Version ${_packageInfo!.version} (${_packageInfo!.buildNumber})'
                        : 'Loading version...',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Description card
            _InfoCard(
              title: 'About the App',
              child: const Text(
                'Fix My Town is a civic issue reporting platform that connects citizens with local authorities. Report potholes, broken streetlights, garbage, and water leakage issues directly to the responsible authorities in your area.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF374151),
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // App details
            _InfoCard(
              title: 'App Details',
              child: Column(
                children: [
                  _DetailRow(
                    label: 'Version',
                    value: _packageInfo?.version ?? '—',
                  ),
                  _DetailRow(
                    label: 'Build',
                    value: _packageInfo?.buildNumber ?? '—',
                  ),
                  const _DetailRow(label: 'Platform', value: 'Android / iOS'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Features card
            _InfoCard(
              title: 'Features',
              child: Column(
                children: const [
                  _FeatureItem(
                    icon: Icons.report_problem_outlined,
                    text: 'Report civic issues with photos & location',
                  ),
                  _FeatureItem(
                    icon: Icons.track_changes_outlined,
                    text: 'Track status of your reported issues',
                  ),
                  _FeatureItem(
                    icon: Icons.map_outlined,
                    text: 'Pin issue location on map',
                  ),
                  _FeatureItem(
                    icon: Icons.people_outline,
                    text: 'Direct communication with authorities',
                  ),
                  _FeatureItem(
                    icon: Icons.bar_chart_outlined,
                    text: 'View community-wide issue reports',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              '© ${DateTime.now().year} Fix My Town. All rights reserved.',
              style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF1EA095)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
            ),
          ),
        ],
      ),
    );
  }
}
