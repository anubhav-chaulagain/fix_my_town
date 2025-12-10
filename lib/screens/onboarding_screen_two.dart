import 'package:fix_my_town/screens/onboarding_screen_three.dart';
import 'package:fix_my_town/widgets/my_button.dart';
import 'package:flutter/material.dart';

class OnboardingScreenTwo extends StatelessWidget {
  const OnboardingScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    final bool isTablet = width >= 600;

    // Responsive padding
    final horizontalPadding = width * 0.05;
    final verticalPadding = height * 0.05;

    // Responsive font sizes
    final headingFontSize = width * 0.05; // ~5% of width
    final textFontSize = width * 0.045; // slightly smaller

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF1F1F1),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image
              Flexible(
                flex: 3,
                child: Image.asset(
                  "assets/images/report_issue.png",
                  fit: BoxFit.contain,
                  height: height * 0.3,
                ),
              ),
              SizedBox(height: height * 0.03),

              // Texts
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 60 : 10,
                      ),
                      child: Text(
                        "How to report an issue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 28 : headingFontSize,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 60 : 10,
                      ),
                      child: Text(
                        "Take photos",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 24 : textFontSize,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                        softWrap: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 60 : 10,
                      ),
                      child: Text(
                        "Add details",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 24 : textFontSize,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                        softWrap: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 60 : 10,
                      ),
                      child: Text(
                        "Auto GPS tagging",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 24 : textFontSize,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.03),

              // Next button
              MyButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingScreenThree(),
                    ),
                  );
                },
                text: "Next",
                type: MyButtonType.elevated,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
