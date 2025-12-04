import 'package:fix_my_town/widgets/my_button.dart';
import 'package:fix_my_town/widgets/my_text_form_field_login.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController(text: "");

  final TextEditingController emailController = TextEditingController(text: "");

  final _signupKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          border: Border.all(color: Colors.grey),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _signupKey,
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  MyTextFormFieldLogin(
                    controllerVal: nameController,
                    text: "Enter full name",
                    icon: Icons.person,
                    label: "Full Name",
                  ),
                  MyTextFormFieldLogin(
                    controllerVal: emailController,
                    text: "xyz@gmail.com",
                    icon: Icons.email,
                    label: "Email",
                  ),

                  MyTextFormFieldLogin(
                    controllerVal: emailController,
                    text: "Enter password",
                    icon: Icons.key,
                    label: "Password",
                  ),
                  MyTextFormFieldLogin(
                    controllerVal: emailController,
                    text: "Retype password",
                    icon: Icons.password,
                    label: "Confirm Password",
                  ),
                  SizedBox(height: 10),
                  MyButton(
                    onPressed: () {},
                    text: "Signup",
                    type: MyButtonType.elevated,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
