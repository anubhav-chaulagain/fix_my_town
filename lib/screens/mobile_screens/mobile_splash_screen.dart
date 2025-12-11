import 'package:fix_my_town/widgets/my_button.dart';
import 'package:flutter/material.dart';

class MobileSplashScreen extends StatelessWidget {
  const MobileSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/painted_top.jpg"),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 40,
              right: 16,
              bottom: 90,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset("assets/images/logo.png", height: 50),
                    Text(
                      "Report, Resolve and Revive",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors
                            .black, // always use white on splash backgrounds
                      ),
                    ),
                  ],
                ),
                Image.asset("assets/images/splash_screen_front.png"),
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    spacing: 16,
                    children: [
                      MyButton(
                        onPressed: () {},
                        text: "Get Started",
                        type: MyButtonType.outlined,
                      ),
                      MyButton(
                        onPressed: () {},
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
