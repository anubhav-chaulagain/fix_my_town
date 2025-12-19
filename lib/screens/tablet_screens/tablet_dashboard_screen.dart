import 'package:fix_my_town/screens/tablet_screens/tablet_bottom_nav_screens/tablet_home_screen.dart';
import 'package:fix_my_town/screens/tablet_screens/tablet_bottom_nav_screens/tablet_my_reports_screen.dart';
import 'package:fix_my_town/screens/tablet_screens/tablet_bottom_nav_screens/tablet_profile_screen.dart';
import 'package:flutter/material.dart';

class TabletDashboardScreen extends StatefulWidget {
  const TabletDashboardScreen({super.key});

  @override
  State<TabletDashboardScreen> createState() => _TabletDashboardScreenState();
}

class _TabletDashboardScreenState extends State<TabletDashboardScreen> {
  int _selectedIndex = 0;
  List<Widget> bottomScreens = [
    const TabletHomeScreen(),
    const TabletMyReportsScreen(),
    const TabletProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
