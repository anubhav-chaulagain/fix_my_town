import 'package:flutter/material.dart';

enum MyButtonType { elevated, outlined }

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.type,
    this.width,
  });

  final VoidCallback onPressed;
  final String text;
  final MyButtonType type;
  final double? width;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MyButtonType.elevated:
        return SizedBox(
          width: width ?? double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFF1EA095),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        );
      case MyButtonType.outlined:
        return SizedBox(
          width: width ?? double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: const Color(0xFF1EA095), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              text,
              style: TextStyle(color: const Color(0xFF1EA095), fontSize: 20),
            ),
          ),
        );
    }
  }
}
