import 'dart:io';

import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/core/utils/snackbar_utils.dart';
import 'package:fix_my_town/core/widgets/my_button.dart';
import 'package:fix_my_town/core/widgets/my_text_form_field_login.dart';
import 'package:fix_my_town/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MobileEditProfileScreen extends ConsumerStatefulWidget {
  const MobileEditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MobileEditProfileScreenState();
}

class _MobileEditProfileScreenState
    extends ConsumerState<MobileEditProfileScreen> {
  final _editProfileKey = GlobalKey<FormState>();

  // Future<void> _handleSubmit() async {
  //   if (_editProfileKey.currentState!.validate()) {
  //     final userSessionService = ref.read(userSessionServiceProvider);
  //     final userId = userSessionService.getUserId();
  //     final uploadedPhotoUrl = ref.read(authViewmodelProvider).uploadedPhotoUrl;

  //     // update user data logic --

  //   }
  // }

  // Media selection
  final List<XFile> _selectedMedia = []; // images or video
  final ImagePicker _imagePicker = ImagePicker();

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }

    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
          "This feature requires permission to access your camera or gallery. Please enable it in your device settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // code for camera
  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _selectedMedia.clear();
        _selectedMedia.add(photo);
      });
      // Upload photo to server
      await ref
          .read(authViewmodelProvider.notifier)
          .uploadPhoto(File(photo.path));
    }
  }

  // code for gallery
  Future<void> _pickFromGallery({bool allowMultiple = false}) async {
    try {
      if (allowMultiple) {
        final List<XFile> images = await _imagePicker.pickMultiImage(
          imageQuality: 80,
        );

        if (images.isNotEmpty) {
          setState(() {
            _selectedMedia.clear();
            _selectedMedia.addAll(images);
          });
          // Upload first photo to server
          await ref
              .read(authViewmodelProvider.notifier)
              .uploadPhoto(File(images.first.path));
        }
      } else {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );

        if (image != null) {
          setState(() {
            _selectedMedia.clear();
            _selectedMedia.add(image);
          });
          // Upload photo to server
          await ref
              .read(authViewmodelProvider.notifier)
              .uploadPhoto(File(image.path));
        }
      }
    } catch (e) {
      debugPrint('Gallery Error $e');

      if (mounted) {
        SnackbarUtils.showError(
          context,
          'Unable to access gallery. Please try using the camera instead.',
        );
      }
    }
  }

  // code for dialogBox : showDialog for menu
  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.browse_gallery),
                title: Text('Open Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                  GestureDetector(
                    onTap: () {
                      _pickMedia();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1EA095),
                            borderRadius: BorderRadius.circular(40),
                            image: _selectedMedia.isNotEmpty
                                ? DecorationImage(
                                    image: FileImage(
                                      File(_selectedMedia[0].path),
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _selectedMedia.isEmpty
                              ? const Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                  size: 40,
                                )
                              : null,
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
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
