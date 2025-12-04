import 'package:fix_my_town/screens/onboarding_screen_one.dart';
import 'package:fix_my_town/screens/onboarding_screen_three.dart';
import 'package:fix_my_town/screens/onboarding_screen_two.dart';
import 'package:fix_my_town/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreenThree(),
    );
  }
}
