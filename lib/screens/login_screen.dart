import 'package:fix_my_town/screens/mobile_screens/mobile_login_screen.dart';
import 'package:fix_my_town/screens/tablet_screens/tablet_login_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return MobileLoginScreen();
        } else {
          return TabletLoginScreen();
        }
      },
    );
  }
}
