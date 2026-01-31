import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/core/widgets/my_button.dart';
import 'package:fix_my_town/core/widgets/my_text_form_field_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileEditProfileScreen extends ConsumerStatefulWidget {
  const MobileEditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MobileEditProfileScreenState();
}

class _MobileEditProfileScreenState
    extends ConsumerState<MobileEditProfileScreen> {
  final _editProfileKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _userSessionService = ref.read(userSessionServiceProvider);
    final TextEditingController nameController = TextEditingController(
      text: _userSessionService.getFullname(),
    );

    final TextEditingController emailController = TextEditingController(
      text: _userSessionService.getUserEmail(),
    );
    final TextEditingController currPassController = TextEditingController(
      text: "",
    );

    final TextEditingController newPassController = TextEditingController(
      text: "",
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _editProfileKey,
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFF1EA095),
                        radius: 40,
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),

                  MyTextFormFieldLogin(
                    controllerVal: nameController,
                    text: "Enter full name",
                    icon: Icons.person,
                    label: "Full Name",
                    disabled: false,
                  ),
                  MyTextFormFieldLogin(
                    controllerVal: emailController,
                    text: "xyz@gmail.com",
                    icon: Icons.email,
                    label: "Email",
                    disabled: true,
                  ),

                  MyTextFormFieldLogin(
                    controllerVal: currPassController,
                    text: "Enter current passowrd",
                    icon: Icons.key,
                    label: "Current Password",
                    disabled: false,
                  ),
                  MyTextFormFieldLogin(
                    controllerVal: newPassController,
                    text: "Enter new password",
                    icon: Icons.password,
                    label: "New Password",
                    disabled: false,
                  ),
                  SizedBox(height: 10),
                  MyButton(
                    onPressed: () {
                      if (_editProfileKey.currentState!.validate()) {
                        // ref
                        //     .read(authViewmodelProvider.notifier)
                        //     .register(
                        //       fullName: nameController.text,
                        //       email: emailController.text,
                        //       password: passController.text,
                        //       role: "user",
                        //     );
                      }
                    },
                    text: "Edit Profile",
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
