import 'package:fix_my_town/widgets/my_button.dart';
import 'package:fix_my_town/widgets/my_onboarding_card_label.dart';
import 'package:flutter/material.dart';

class TabletOnboardingScreen extends StatelessWidget {
  const TabletOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            SizedBox(
              width: 350,
              height: 550,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Card(
                    borderOnForeground: true,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
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
                        ],
                      ),
                    ),
                  ),
                  MyOnboardingCardLabel(text: "1"),
                ],
              ),
            ),
            SizedBox(
              width: 350,
              height: 550,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Card(
                    borderOnForeground: true,
                    color: Colors.white,
                    surfaceTintColor: Colors.yellow,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Image.asset("assets/images/report_issue.png"),
                          SizedBox(height: 24),
                          Text(
                            "How to report an issue",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "Take photos",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "Add details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "Auto GPS tagging",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  MyOnboardingCardLabel(text: "2"),
                ],
              ),
            ),
            SizedBox(
              width: 350,
              height: 550,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Card(
                    borderOnForeground: true,
                    color: Colors.white,
                    surfaceTintColor: Colors.yellow,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Image.asset("assets/images/reporting_process.png"),
                          SizedBox(height: 24),
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
                        ],
                      ),
                    ),
                  ),
                  MyOnboardingCardLabel(text: "3"),
                  Positioned(
                    right: 0,
                    bottom: -60,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Get Started -->",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
