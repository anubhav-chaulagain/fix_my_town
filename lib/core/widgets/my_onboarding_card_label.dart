import 'package:flutter/material.dart';

class MyOnboardingCardLabel extends StatelessWidget {
  const MyOnboardingCardLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -15,
      right: -15,
      child: Container(
        width: 75,
        height: 75,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36.5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 1),
              blurRadius: 1,
              color: Colors.black.withValues(alpha: 0.15),
              spreadRadius: 1,
            ),
          ],
        ),

        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 5,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
