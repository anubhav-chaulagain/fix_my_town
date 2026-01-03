import 'package:fix_my_town/core/utils/snackbar_utils.dart';
import 'package:fix_my_town/features/auth/presentation/state/auth_state.dart';
import 'package:fix_my_town/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:fix_my_town/features/auth/presentation/pages/login_screen.dart';
import 'package:fix_my_town/core/widgets/my_button.dart';
import 'package:fix_my_town/core/widgets/my_text_form_field_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabletSignupScreen extends ConsumerStatefulWidget {
  const TabletSignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TabletSignupScreenState();
}

class _TabletSignupScreenState extends ConsumerState<TabletSignupScreen> {
  final TextEditingController nameController = TextEditingController(text: "");

  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passController = TextEditingController(text: "");

  final TextEditingController conPassController = TextEditingController(
    text: "",
  );

  final _tabletSignupKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewmodelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "An error occurred",
        );
      } else if (next.status == AuthStatus.registered) {
        SnackbarUtils.showSuccess(context, "Logged In Successfully!");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
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
                  key: _tabletSignupKey,
                  child: Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
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
                        controllerVal: passController,
                        text: "Enter password",
                        icon: Icons.key,
                        label: "Password",
                      ),
                      MyTextFormFieldLogin(
                        controllerVal: conPassController,
                        text: "Retype password",
                        icon: Icons.password,
                        label: "Confirm Password",
                      ),
                      SizedBox(height: 10),
                      MyButton(
                        onPressed: () {
                          if (_tabletSignupKey.currentState!.validate()) {
                            ref
                                .read(authViewmodelProvider.notifier)
                                .register(
                                  fullName: nameController.text,
                                  email: emailController.text,
                                  password: passController.text,
                                  role: "user",
                                );
                          }
                        },
                        text: "Signup",
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
  }
}
