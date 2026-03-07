import 'package:flutter/material.dart';

class MyIssueCountCard extends StatelessWidget {
  const MyIssueCountCard({super.key, required this.myIssue});

  final Map<String, String> myIssue;

  @override
  Widget build(BuildContext context) {
    _CardStyle style = _getStyle(myIssue["title"] ?? '');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: style.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: style.gradientColors.first.withValues(alpha: .35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon bubble
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(style.icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  myIssue["count"] ?? "0",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  myIssue["title"] ?? "",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: .85),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _CardStyle _getStyle(String title) {
    switch (title.toLowerCase()) {
      case 'total reports':
        return _CardStyle(
          gradientColors: const [Color(0xFF1EA095), Color(0xFF0D7A70)],
          icon: Icons.bar_chart_rounded,
        );
      case 'resolved':
        return _CardStyle(
          gradientColors: const [Color(0xFF059669), Color(0xFF047857)],
          icon: Icons.check_circle_outline_rounded,
        );
      case 'pending':
        return _CardStyle(
          gradientColors: const [Color(0xFFD97706), Color(0xFFB45309)],
          icon: Icons.hourglass_empty_rounded,
        );
      case 'in progress':
        return _CardStyle(
          gradientColors: const [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          icon: Icons.timelapse_rounded,
        );
      default:
        return _CardStyle(
          gradientColors: const [Color(0xFF6B7280), Color(0xFF4B5563)],
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

class _CardStyle {
  final List<Color> gradientColors;
  final IconData icon;

  _CardStyle({required this.gradientColors, required this.icon});
}
