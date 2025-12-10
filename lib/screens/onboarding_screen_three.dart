import 'package:fix_my_town/screens/signup_screen.dart';
import 'package:fix_my_town/widgets/my_button.dart';
import 'package:flutter/material.dart';

class OnboardingScreenThree extends StatelessWidget {
  const OnboardingScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final isTablet = width > 600; // simple tablet check

    final horizontalPadding = isTablet ? 60.0 : 20.0;
    final verticalPadding = isTablet ? 60.0 : 40.0;

    final headingFontSize = isTablet ? 28.0 : 20.0;
    final detailFontSize = isTablet ? 24.0 : 20.0;

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
              Flexible(
                flex: 3,
                child: Image.asset(
                  "assets/images/reporting_process.png",
                  fit: BoxFit.contain,
                  height: height * 0.3, // scales with screen height
                ),
              ),
              SizedBox(height: height * 0.03),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  "You can track progress:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: headingFontSize,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                  softWrap: true,
                ),
              ),
              SizedBox(height: height * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  "Submitted → Assigned → In Progress → Resolved",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: detailFontSize,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                  softWrap: true,
                ),
              ),
              SizedBox(height: height * 0.03),

              // Next button
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
        ),
      ),
    );
  }
}
