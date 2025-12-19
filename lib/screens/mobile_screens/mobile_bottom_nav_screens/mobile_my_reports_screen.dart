import 'package:fix_my_town/widgets/my_issue_card.dart';
import 'package:fix_my_town/widgets/my_issue_count_card.dart';
import 'package:flutter/material.dart';

class MobileMyReportsScreen extends StatelessWidget {
  const MobileMyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> issueCards = [
      {
        "title": "Unmanaged Garbage",
        "address": "Dillibazar, Kathmandu",
        "issueDate": "Dec 12, 2025",
        "status": "Resolved",
        "imageLink":
            "https://res.cloudinary.com/dvimlrbzd/image/upload/v1765790816/garbage_egmctn.jpg",
      },
      {
        "title": "Pothole on Main Road",
        "address": "Ring Road, Kalanki",
        "issueDate": "Dec 14, 2025",
        "status": "In Progress",
        "imageLink":
            "https://res.cloudinary.com/dvimlrbzd/image/upload/v1765808474/raods_jgwghy.jpg",
      },
      {
        "title": "Street Light Not Working",
        "address": "Lazimpat Chowk",
        "issueDate": "Dec 15, 2025",
        "status": "Submitted",
        "imageLink":
            "https://res.cloudinary.com/dvimlrbzd/image/upload/v1765808519/lights_gwll9m.jpg",
      },
      {
        "title": "Water Leakage",
        "address": "New Baneshwor",
        "issueDate": "Dec 13, 2025",
        "status": "In Progress",
        "imageLink":
            "https://res.cloudinary.com/dvimlrbzd/image/upload/v1765808611/water_leakage_sekrxw.jpg",
      },
      {
        "title": "Broken Drain Cover",
        "address": "Koteshwor Bus Stop",
        "issueDate": "Dec 10, 2025",
        "status": "Resolved",
        "imageLink":
            "https://res.cloudinary.com/dvimlrbzd/image/upload/v1765808610/drain_cover_damge_hubsmh.jpg",
      },
    ];

    final List<Map<String, String>> issuesCount = [
      {"count": "12", "title": "Issues Reported"},
      {"count": "8", "title": "Resolved"},
    ];
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "My Reports",
                style: TextStyle(fontFamily: "Roboto Bold", fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  const spacing = 20.0;
                  const crossAxisCount = 2;

                  final cardWidth =
                      (constraints.maxWidth - spacing) / crossAxisCount;
                  final cardHeight = cardWidth;

                  final rows = (issuesCount.length / crossAxisCount).ceil();
                  final gridHeight =
                      (rows * cardHeight) + ((rows - 1) * spacing);
                  return SizedBox(
                    height: gridHeight,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                      ),
                      itemCount: issuesCount.length,
                      itemBuilder: (context, index) {
                        final issueC = issuesCount[index];
                        return MyIssueCountCard(myIssue: issueC);
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Recent Reports",
                style: TextStyle(fontFamily: "Roboto Bold", fontSize: 20),
              ),
            ),
            ListView.separated(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: issueCards.length,
              itemBuilder: (context, index) {
                final issue = issueCards[index];
                return MyIssueCard(
                  title: issue["title"]!,
                  address: issue["address"]!,
                  img: issue["imageLink"]!,
                  status: issue["status"]!,
                  issueDate: issue["issueDate"]!,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 12);
              },
            ),
          ],
        ),
      ),
    );
  }
}
