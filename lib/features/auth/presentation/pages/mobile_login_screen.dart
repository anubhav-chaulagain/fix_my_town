import 'package:fix_my_town/app/routes/app_routes.dart';
import 'package:fix_my_town/core/utils/snackbar_utils.dart';
import 'package:fix_my_town/features/auth/presentation/pages/signup_screen.dart';
import 'package:fix_my_town/features/auth/presentation/state/auth_state.dart';
import 'package:fix_my_town/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:fix_my_town/core/widgets/my_button.dart';
import 'package:fix_my_town/core/widgets/my_text_form_field_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileLoginScreen extends ConsumerStatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MobileLoginScreenState();
}

class _MobileLoginScreenState extends ConsumerState<MobileLoginScreen> {
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passController = TextEditingController(text: "");

  final _loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewmodelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "An error occurred",
        );
      } else if (next.status == AuthStatus.authenticated) {
        SnackbarUtils.showSuccess(context, "Logged In Successfully!");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    });
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
                    disabled: false,
                  ),

                  MyTextFormFieldLogin(
                    controllerVal: passController,
                    text: "Enter password",
                    icon: Icons.key,
                    label: "Password",
                    disabled: false,
                  ),
                  SizedBox(height: 10),
                  MyButton(
                    onPressed: () {
                      if (_loginKey.currentState!.validate()) {
                        ref
                            .read(authViewmodelProvider.notifier)
                            .login(
                              email: emailController.text,
                              password: passController.text.trim(),
                            );
                      }
                    },
                    text: "Login",
                    type: MyButtonType.elevated,
                  ),
                  TextButton(
                    onPressed: () {
                      AppRoutes.pushAndRemoveUntil(context, SignupScreen());
                    },
                    child: Text("Don't have an account?"),
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
