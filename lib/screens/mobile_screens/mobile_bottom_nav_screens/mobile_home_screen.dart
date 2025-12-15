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
        "descText":
            "There has not been the collection of garbage in the area for a long time which is really causing the land and air pollution.",
        "imageLink":
            "https://res.cloudinary.com/dvimlrbzd/image/upload/v1765790816/garbage_egmctn.jpg",
      },
      {
        "title": "Pothole on Main Road",
        "address": "Ring Road, Kalanki",
        "descText":
            "Large pothole causing traffic congestion and frequent vehicle damage.",
        "imageLink":
            "https://res.cloudinary.com/dvimlrbzd/image/upload/v1765808474/raods_jgwghy.jpg",
      },
      {
        "title": "Street Light Not Working",
        "address": "Lazimpat Chowk",
        "descText":
            "Street light has been off for weeks, making the area unsafe at night.",
        "imageLink":
            "https://res.cloudinary.com/dvimlrbzd/image/upload/v1765808519/lights_gwll9m.jpg",
      },
      {
        "title": "Water Leakage",
        "address": "New Baneshwor",
        "descText":
            "Continuous water leakage from underground pipe wasting clean water.",
        "imageLink":
            "https://res.cloudinary.com/dvimlrbzd/image/upload/v1765808611/water_leakage_sekrxw.jpg",
      },
      {
        "title": "Broken Drain Cover",
        "address": "Koteshwor Bus Stop",
        "descText":
            "Open drain with broken cover posing danger to pedestrians.",
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
          desc: issue["descText"]!,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 12);
      },
    );
  }
}
