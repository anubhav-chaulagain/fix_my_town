import 'package:fix_my_town/model/category_model.dart';
import 'package:flutter/material.dart';

class MyCategoryCard extends StatelessWidget {
  const MyCategoryCard({super.key, required this.category});

  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: category.color,
          gradient: LinearGradient(colors: category.gradient),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(category.icon, color: Colors.white, size: 40),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Roboto Bold",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
