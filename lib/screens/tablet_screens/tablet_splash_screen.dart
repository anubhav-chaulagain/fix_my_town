import 'package:fix_my_town/screens/onboarding_screen.dart';
import 'package:fix_my_town/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TabletSplashScreen extends StatelessWidget {
  const TabletSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              "assets/images/Image.svg",
              fit: BoxFit.fitWidth, // Same as your JPG
              alignment: Alignment.topCenter,
            ),
          ),

          Container(
            width: double.infinity,
            height: double.infinity,
            child: SafeArea(
              child: Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 60,
                    top: 60,
                    right: 30,
                    bottom: 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/logo.png", height: 60),
                          SizedBox(height: 52),
                          Text(
                            "Report, Resolve",
                            style: TextStyle(
                              fontSize: 60,
                              height: 0.4,
                              fontFamily: "Otomanopee One",
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            spacing: 16,
                            children: [
                              Text(
                                "&",
                                style: TextStyle(
                                  fontSize: 80,
                                  fontFamily: "Otomanopee One",
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Revive",
                                style: TextStyle(
                                  fontSize: 60,
                                  fontFamily: "Otomanopee One",
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                MyButton(
                                  onPressed: () {},
                                  text: "Get Started",
                                  type: MyButtonType.outlined,
                                  width: 200,
                                ),
                                SizedBox(width: 32),
                                MyButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const OnboardingScreen(),
                                      ),
                                    );
                                  },
                                  text: "Log In",
                                  type: MyButtonType.elevated,
                                  width: 200,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Image.asset(
                                  "assets/images/splash_screen_front.png",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
