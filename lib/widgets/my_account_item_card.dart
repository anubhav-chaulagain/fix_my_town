import 'package:fix_my_town/model/account_item_model.dart';
import 'package:flutter/material.dart';

class MyAccountItemCard extends StatelessWidget {
  const MyAccountItemCard({super.key, required this.item});

  final AccountItem item;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: item.color.withValues(alpha: 0.2),
          child: Icon(Icons.person_outline, color: item.color),
        ),
        title: Text(item.label, style: TextStyle(fontFamily: "Roboto Bold")),
        trailing: Icon(Icons.chevron_right, color: Color(0xff6b7280)),
      ),
    );
    ;
  }
}
