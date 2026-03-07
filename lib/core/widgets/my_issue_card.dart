import 'package:fix_my_town/model/status_color_model.dart';
import 'package:flutter/material.dart';

class MyIssueCard extends StatelessWidget {
  const MyIssueCard({
    super.key,
    required this.title,
    required this.address,
    required this.img,
    required this.status,
    required this.issueDate,
    this.description,
  });

  final String title;
  final String address;
  final String img;
  final String status;
  final String issueDate;
  final String? description;

  @override
  Widget build(BuildContext context) {
    String shorten(String text, {int max = 22}) {
      if (text.length <= max) return text;
      return '${text.substring(0, max)}..';
    }

    String formatDate(String raw) {
      if (raw.isEmpty) return '';
      try {
        final dt = DateTime.parse(raw).toLocal();
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
      } catch (_) {
        return raw;
      }
    }

    StatusColorModel statusColors(String status) {
      switch (status.toLowerCase()) {
        case 'open':
        case 'submitted':
        case 'pending':
          return const StatusColorModel(
            Color(0xFFB45309),
            Color(0xFFFEF3C7),
          ); // amber
        case 'in_progress':
        case 'in progress':
          return const StatusColorModel(
            Color(0xFF1D4ED8),
            Color(0xFFDBEAFE),
          ); // blue
        case 'resolved':
          return const StatusColorModel(
            Color(0xFF059669),
            Color(0xFFDCFCE7),
          ); // green
        case 'rejected':
        case 'closed':
          return const StatusColorModel(
            Color(0xFFDC2626),
            Color(0xFFFEE2E2),
          ); // red
        default:
          return const StatusColorModel(
            Color(0xFF6B7280),
            Color(0xFFF3F4F6),
          ); // grey
      }
    }

    String formatStatus(String s) {
      switch (s.toLowerCase()) {
        case 'open':
          return 'Open';
        case 'pending':
          return 'Pending';
        case 'in_progress':
          return 'In Progress';
        case 'resolved':
          return 'Resolved';
        case 'rejected':
          return 'Rejected';
        case 'closed':
          return 'Closed';
        default:
          return s;
      }
    }

    final statColor = statusColors(status);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ─────────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: img.isNotEmpty
                  ? Image.network(
                      img,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _Placeholder(),
                    )
                  : _Placeholder(),
            ),

            const SizedBox(width: 12),

            // ── Text Content ──────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + badge row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          shorten(title, max: 26),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statColor.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          formatStatus(status),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statColor.text,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Description
                  if (description != null && description!.isNotEmpty)
                    Text(
                      shorten(description!, max: 55),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Address + Date
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        shorten(address, max: 20),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        formatDate(issueDate),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Color(0xFFCBD5E1),
        size: 28,
      ),
    );
  }
}
