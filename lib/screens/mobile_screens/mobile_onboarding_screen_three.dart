import 'package:fix_my_town/screens/mobile_screens/mobile_signup_screen.dart';
import 'package:fix_my_town/screens/signup_screen.dart';
import 'package:fix_my_town/widgets/my_button.dart';
import 'package:fix_my_town/widgets/my_skip_button.dart';
import 'package:flutter/material.dart';

class MobileOnboardingScreenThree extends StatelessWidget {
  const MobileOnboardingScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        border: Border.all(color: Colors.grey),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: .5,
                spreadRadius: 3,
                offset: Offset(1.5, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Image.asset("assets/images/reporting_process.png"),
                    Text(
                      "You can track progress:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Submitted → Assigned → In Progress → Resolved",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Spacer(),
                    MyButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      text: "Next",
                      type: MyButtonType.elevated,
                    ),
                  ],
                ),
                MySkipButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
