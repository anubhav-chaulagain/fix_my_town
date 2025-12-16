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
  });

  final String title;
  final String address;
  final String img;
  final String status;
  final String issueDate;

  @override
  Widget build(BuildContext context) {
    String shorten(String text, {int max = 22}) {
      if (text.length <= max) return text;
      return '${text.substring(0, max)}..';
    }

    StatusColorModel statusColors(String status) {
      if (status == "Submitted") {
        return const StatusColorModel(Color(0xFF3730A3), Color(0xFFE0E7FF));
      } else if (status == "In Progress") {
        return const StatusColorModel(Color(0xFFD97706), Color(0xFFFEF3C7));
      } else {
        return const StatusColorModel(Color(0xFF059669), Color(0xFFDCFCE7));
      }
    }

    final StatusColorModel statColor = statusColors(status);

    return InkWell(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shorten(title),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          // Icon(Icons.pin_drop_outlined, size: 16),
                          Text(
                            address,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(img, width: 100, fit: BoxFit.cover),
                ),
              ],
            ),
            SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(issueDate, style: TextStyle(color: Color(0xFF9CA3AF))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: statColor.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontFamily: "Roboto Bold",
                      fontSize: 12,
                      color: statColor.text,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
