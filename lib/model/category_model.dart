import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final String name;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.gradient,
  });
}
