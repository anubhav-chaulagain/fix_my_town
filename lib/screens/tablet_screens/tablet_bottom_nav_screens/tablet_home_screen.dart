import 'package:fix_my_town/model/category_model.dart';
import 'package:fix_my_town/widgets/my_category_card.dart';
import 'package:fix_my_town/widgets/my_issue_card.dart';
import 'package:flutter/material.dart';

class TabletHomeScreen extends StatelessWidget {
  const TabletHomeScreen({super.key});

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

    final List<CategoryModel> categories = [
      CategoryModel(
        id: 1,
        name: 'Garbage',
        icon: Icons.delete_outline,
        color: const Color(0xFF059669),
        gradient: const [Color(0xFF059669), Color(0xFF047857)],
      ),
      CategoryModel(
        id: 2,
        name: 'Road Damage',
        icon: Icons.report_problem_outlined,
        color: const Color(0xFFDC2626),
        gradient: const [Color(0xFFDC2626), Color(0xFFB91C1C)],
      ),
      CategoryModel(
        id: 3,
        name: 'Street Lights',
        icon: Icons.lightbulb_outline,
        color: const Color(0xFFF59E0B),
        gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
      ),
      CategoryModel(
        id: 4,
        name: 'Water',
        icon: Icons.water_drop_outlined,
        color: const Color(0xFF2563EB),
        gradient: const [Color(0xFF2563EB), Color(0xFF1E40AF)],
      ),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Text(
                    "Welcome back!",
                    style: TextStyle(fontFamily: "Roboto Bold", fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Select an category to get started",
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      top: 10,
                    ),
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                            const spacing = 12.0;
                            const crossAxisCount = 2;

                            final cardWidth =
                                (constraints.maxWidth - spacing) /
                                crossAxisCount;
                            final cardHeight = cardWidth;

                            final rows = (categories.length / crossAxisCount)
                                .ceil();
                            final gridHeight =
                                (rows * cardHeight) + ((rows - 1) * spacing);
                            return SizedBox(
                              height: gridHeight,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: spacing,
                                      mainAxisSpacing: spacing,
                                    ),
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  return MyCategoryCard(category: category);
                                },
                              ),
                            );
                          },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Recent Activity",
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
        ),
      ),
    );
  }
}
