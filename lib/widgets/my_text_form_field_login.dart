import 'package:flutter/material.dart';

class MyTextFormFieldLogin extends StatelessWidget {
  const MyTextFormFieldLogin({
    super.key,
    required this.controllerVal,
    required this.text,
    required this.icon,
    required this.label,
  });

  final TextEditingController controllerVal;
  final String label;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerVal,
      decoration: InputDecoration(
        labelText: label,
        hintText: text,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter some text";
        }
        return null;
      },
    );
  }
}
