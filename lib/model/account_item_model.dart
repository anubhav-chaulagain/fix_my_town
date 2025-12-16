import 'package:flutter/material.dart';

class AccountItem {
  final int id;
  final String label;
  final IconData icon;
  final Color color;

  const AccountItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}
