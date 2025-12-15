import 'package:fix_my_town/screens/mobile_screens/mobile_bottom_nav_screens/mobile_home_screen.dart';
import 'package:fix_my_town/screens/mobile_screens/mobile_bottom_nav_screens/mobile_my_reports_screen.dart';
import 'package:fix_my_town/screens/mobile_screens/mobile_bottom_nav_screens/mobile_profile_screen.dart';
import 'package:flutter/material.dart';

class MobileDashboardScreen extends StatefulWidget {
  const MobileDashboardScreen({super.key});

  @override
  State<MobileDashboardScreen> createState() => _MobileDashboardScreenState();
}

class _MobileDashboardScreenState extends State<MobileDashboardScreen> {
  int _selectedIndex = 0;
  List<Widget> bottomScreens = [
    const MobileHomeScreen(),
    const MobileMyReportsScreen(),
    const MobileProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: bottomScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _selectedIndex == 0
                    ? Colors.grey[200]
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.home),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _selectedIndex == 1
                    ? Colors.grey[200]
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.bar_chart),
            ),
            label: "My Reports",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _selectedIndex == 2
                    ? Colors.grey[200]
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(Icons.person),
            ),
            label: "Profile",
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
      ),
    );
  }
}
