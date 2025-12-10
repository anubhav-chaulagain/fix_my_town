import 'package:fix_my_town/screens/onboarding_screen_two.dart';
import 'package:fix_my_town/widgets/my_button.dart';
import 'package:flutter/material.dart';

class OnboardingScreenOne extends StatelessWidget {
  const OnboardingScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final bool isTablet = width >= 600;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        border: Border.all(color: Colors.grey),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 40 : 20,
        vertical: isTablet ? 60 : 40,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top Spacer removed; replaced with flexible layout
            Expanded(
              flex: isTablet ? 5 : 4,
              child: Center(
                child: Image.asset(
                  "assets/images/problems.png",
                  width: isTablet ? width * 0.5 : width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(height: isTablet ? 40 : 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 60 : 10),
              child: Text(
                "Capture local problems and report them directly to your municipality.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isTablet ? 28 : 20,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),

            SizedBox(height: isTablet ? 60 : 40),

            // Bottom button stays fixed
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 80 : 20),
              child: MyButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingScreenTwo(),
                    ),
                  );
                },
                text: "Next",
                type: MyButtonType.elevated,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
