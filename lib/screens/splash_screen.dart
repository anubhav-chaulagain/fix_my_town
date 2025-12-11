import 'package:fix_my_town/screens/mobile_screens/mobile_splash_screen.dart';
import 'package:fix_my_town/screens/tablet_screens/tablet_splash_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return MobileSplashScreen();
        } else {
          return TabletSplashScreen();
        }
      },
    );
  }
}
