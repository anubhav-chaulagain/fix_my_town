import 'package:flutter/material.dart';

class MyIssueCountCard extends StatelessWidget {
  const MyIssueCountCard({super.key, required this.myIssue});

  final Map<String, String> myIssue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .3),
            blurRadius: 8,
            offset: const Offset(2, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Text(
            myIssue["count"] ?? "0",
            style: TextStyle(
              fontFamily: "Roboto Bold",
              fontSize: 22,
              color: Color(0xff2563eb),
            ),
          ),
          Text(
            myIssue["title"] ?? "",
            style: TextStyle(fontSize: 12, color: Color(0xff6b7280)),
          ),
        ],
      ),
    );
  }
}
