import 'package:fix_my_town/widgets/my_issue_card.dart';
import 'package:flutter/material.dart';

class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({super.key});

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

    return ListView.separated(
      padding: EdgeInsets.all(20),
      shrinkWrap: true,
      physics: RangeMaintainingScrollPhysics(),
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
    );
  }
}
