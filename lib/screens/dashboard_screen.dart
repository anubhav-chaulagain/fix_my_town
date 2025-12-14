import 'package:fix_my_town/screens/mobile_screens/mobile_dashboard_screen.dart';
import 'package:fix_my_town/screens/tablet_screens/tablet_dashboard_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return MobileDashboardScreen();
        } else {
          return TabletDashboardScreen();
        }
      },
    );
  }
}
