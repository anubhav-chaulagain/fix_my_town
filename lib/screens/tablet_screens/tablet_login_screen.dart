import 'package:fix_my_town/widgets/my_button.dart';
import 'package:fix_my_town/widgets/my_text_form_field_login.dart';
import 'package:flutter/material.dart';

class TabletLoginScreen extends StatefulWidget {
  const TabletLoginScreen({super.key});

  @override
  State<TabletLoginScreen> createState() => _TabletLoginScreenState();
}

class _TabletLoginScreenState extends State<TabletLoginScreen> {
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passController = TextEditingController(text: "");

  final _tabletLoginKey = GlobalKey<FormState>();
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 80),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: .5,
                      spreadRadius: 2,
                      offset: Offset(1.5, 1),
                    ),
                  ],
                ),
                child: Form(
                  key: _tabletLoginKey,
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      MyTextFormFieldLogin(
                        controllerVal: emailController,
                        text: "xyz@gmail.com",
                        icon: Icons.email,
                        label: "Email",
                      ),

                      MyTextFormFieldLogin(
                        controllerVal: passController,
                        text: "Enter password",
                        icon: Icons.key,
                        label: "Password",
                      ),
                      SizedBox(height: 10),
                      MyButton(
                        onPressed: () {},
                        text: "Login",
                        type: MyButtonType.elevated,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
