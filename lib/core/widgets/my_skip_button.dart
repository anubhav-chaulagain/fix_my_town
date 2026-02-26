import 'package:fix_my_town/app/routes/app_routes.dart';
import 'package:fix_my_town/features/auth/presentation/pages/signup_screen.dart';
import 'package:flutter/material.dart';

class MySkipButton extends StatelessWidget {
  const MySkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: SizedBox(
        child: TextButton(
          onPressed: () {
            AppRoutes.pushAndRemoveUntil(context, SignupScreen());
          },
          style: ElevatedButton.styleFrom(),
          child: Text(
            "Skip",
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 76, 76, 76),
            ),
          ),
        ),
      ),
    );
  }
}
