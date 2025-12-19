import 'package:fix_my_town/screens/dashboard_screen.dart';
import 'package:fix_my_town/screens/mobile_screens/mobile_dashboard_screen.dart';
import 'package:fix_my_town/theme/theme_data.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
      theme: getApplicationTheme(),
    );
  }
}
