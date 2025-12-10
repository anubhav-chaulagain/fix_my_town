import 'package:fix_my_town/screens/onboarding_screen_one.dart';
import 'package:fix_my_town/widgets/my_button.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final bool isTablet = width >= 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/painted_top.jpg"),
            fit: isTablet ? BoxFit.cover : BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: isTablet ? 40 : 16,
              right: isTablet ? 40 : 16,
              top: isTablet ? 60 : 40,
              bottom: isTablet ? 120 : 90,
            ),
            child: Column(
              children: [
                // Top logo + title
                Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: isTablet ? 90 : 50,
                    ),
                    Text(
                      "Report, Resolve and Revive",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 40 : 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                // THIS IS WHAT FIXES THE OVERFLOW:
                // Let the middle image take only the available space.
                Expanded(
                  child: Center(
                    child: Image.asset(
                      "assets/images/splash_screen_front.png",
                      width: isTablet ? width * 0.6 : width * 0.8,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Buttons at bottom
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 80 : 40),
                  child: Column(
                    spacing: isTablet ? 24 : 16,
                    children: [
                      MyButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingScreenOne(),
                            ),
                          );
                        },
                        text: "Get Started",
                        type: MyButtonType.outlined,
                      ),
                      MyButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingScreenOne(),
                            ),
                          );
                        },
                        text: "Login",
                        type: MyButtonType.elevated,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
