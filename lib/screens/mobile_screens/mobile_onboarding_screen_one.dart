import 'package:fix_my_town/screens/mobile_screens/mobile_onboarding_screen_two.dart';
import 'package:fix_my_town/widgets/my_button.dart';
import 'package:fix_my_town/widgets/my_skip_button.dart';
import 'package:flutter/material.dart';

class MobileOnboardingScreenOne extends StatelessWidget {
  const MobileOnboardingScreenOne({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        border: Border.all(color: Colors.grey),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                    Image.asset("assets/images/problems.png"),
                    SizedBox(height: 24),
                    Text(
                      "Capture local problems and report them directly to your municipality.",
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
                            builder: (context) =>
                                const MobileOnboardingScreenTwo(),
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
