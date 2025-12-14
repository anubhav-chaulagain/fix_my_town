import 'package:fix_my_town/screens/dashboard_screen.dart';
import 'package:fix_my_town/widgets/my_button.dart';
import 'package:fix_my_town/widgets/my_text_form_field_login.dart';
import 'package:flutter/material.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passController = TextEditingController(text: "");

  final _loginKey = GlobalKey<FormState>();
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
          child: Center(
            child: Form(
              key: _loginKey,
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Log In",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                    onPressed: () {
                      if (_loginKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardScreen(),
                          ),
                        );
                      }
                    },
                    text: "Login",
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
