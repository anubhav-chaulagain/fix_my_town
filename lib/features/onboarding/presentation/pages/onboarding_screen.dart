import 'package:fix_my_town/features/onboarding/presentation/pages/mobile_onboarding_screen_one.dart';
import 'package:fix_my_town/features/onboarding/presentation/pages/tablet_onboarding_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return MobileOnboardingScreenOne();
        } else {
          return TabletOnboardingScreen();
        }
      },
    );
  }
}
