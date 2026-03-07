import 'package:fix_my_town/app/routes/app_routes.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_bottom_nav_screens/mobile_all_reports_screen.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_bottom_nav_screens/mobile_home_screen.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_bottom_nav_screens/mobile_my_reports_screen.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_bottom_nav_screens/mobile_profile_screen.dart';
import 'package:fix_my_town/features/issues/presentation/pages/mobile_report_issue_screen.dart';
import 'package:flutter/material.dart';

class MobileDashboardScreen extends StatefulWidget {
  const MobileDashboardScreen({super.key});

  @override
  State<MobileDashboardScreen> createState() => _MobileDashboardScreenState();
}

class _MobileDashboardScreenState extends State<MobileDashboardScreen> {
  static const primary = Color(0xFF1EA095);

  int _selectedIndex = 0;

  List<Widget> bottomScreens = [
    const MobileHomeScreen(),
    const MobileMyReportsScreen(),
    const MobileAllReportsScreen(),
    const MobileProfileScreen(),
  ];

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? primary : Colors.grey, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomScreens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black38,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_rounded, "Home", 0),
            _buildNavItem(Icons.description_rounded, "My Reports", 1),
            const SizedBox(width: 56), // space for FAB
            _buildNavItem(Icons.bar_chart_rounded, "All Reports", 2),
            _buildNavItem(Icons.person_rounded, "Profile", 3),
          ],
        ),
      ),
      floatingActionButton: PhysicalModel(
        color: Colors.transparent,
        shape: BoxShape.circle,
        shadowColor: primary.withValues(alpha: 0.6),
        elevation: 12,
        child: FloatingActionButton(
          onPressed: () {
            AppRoutes.push(context, const MobileReportIssueScreen());
          },
          backgroundColor: primary,
          shape: const CircleBorder(),
          elevation: 0,
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
