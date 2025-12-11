import 'package:fix_my_town/screens/mobile_screens/mobile_signup_screen.dart';
import 'package:fix_my_town/screens/tablet_screens/tablet_signup_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return MobileSignupScreen();
        } else {
          return TabletSignupScreen();
        }
      },
    );
  }
}
