import 'package:fix_my_town/model/account_item_model.dart';
import 'package:fix_my_town/widgets/my_account_item_card.dart';
import 'package:flutter/material.dart';

class MobileProfileScreen extends StatelessWidget {
  const MobileProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AccountItem> accountItems = [
      AccountItem(
        id: 1,
        label: "Edit Profile",
        icon: Icons.person_outline,
        color: Color(0xFF2563EB),
      ),
      AccountItem(
        id: 2,
        label: "Notifications",
        icon: Icons.notifications_outlined,
        color: Color(0xFFF59E0B),
      ),
      AccountItem(
        id: 3,
        label: "Location Settings",
        icon: Icons.location_on_outlined,
        color: Color(0xFF059669),
      ),
    ];

    final List<AccountItem> supportItems = [
      AccountItem(
        id: 4,
        label: "Privacy Policy",
        icon: Icons.shield_outlined,
        color: const Color(0xFF6B7280),
      ),
      AccountItem(
        id: 5,
        label: "Help & Support",
        icon: Icons.help_outline,
        color: const Color(0xFF6B7280),
      ),
      AccountItem(
        id: 6,
        label: "Terms of Service",
        icon: Icons.description_outlined,
        color: const Color(0xFF6B7280),
      ),
    ];

    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xff2563eb),
                      radius: 40,
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "John Doe",
                      style: TextStyle(fontFamily: "Roboto Bold", fontSize: 20),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "john.doe@example.com",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 42),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "12",
                              style: TextStyle(
                                fontFamily: "Roboto Bold",
                                fontSize: 22,
                                color: Color(0xff2563eb),
                              ),
                            ),
                            Text(
                              "Reports",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff6b7280),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "8",
                              style: TextStyle(
                                fontFamily: "Roboto Bold",
                                fontSize: 22,
                                color: Color(0xff2563eb),
                              ),
                            ),
                            Text(
                              "Received",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff6b7280),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "4",
                              style: TextStyle(
                                fontFamily: "Roboto Bold",
                                fontSize: 22,
                                color: Color(0xff2563eb),
                              ),
                            ),
                            Text(
                              "Pending",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff6b7280),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "ACCOUNT",
                  style: TextStyle(
                    color: Color(0xff6b7280),
                    fontSize: 12,
                    fontFamily: "Roboto Bold",
                  ),
                ),
              ),
              ListView.builder(
                itemCount: accountItems.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  AccountItem item = accountItems[index];
                  return MyAccountItemCard(item: item);
                },
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "SUPPORT",
                  style: TextStyle(
                    color: Color(0xff6b7280),
                    fontSize: 12,
                    fontFamily: "Roboto Bold",
                  ),
                ),
              ),
              ListView.builder(
                itemCount: supportItems.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  AccountItem item = supportItems[index];
                  return MyAccountItemCard(item: item);
                },
              ),
              SizedBox(height: 24),
              Card(
                color: Colors.white,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 6,
                    children: [
                      Icon(Icons.logout, size: 22, color: Color(0xffdc2626)),
                      Text(
                        "Log Out",
                        style: TextStyle(
                          fontFamily: "Roboto Bold",
                          color: Color(0xffdc2626),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
