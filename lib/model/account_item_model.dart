import 'package:flutter/material.dart';

class AccountItem {
  final int id;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const AccountItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });
}
