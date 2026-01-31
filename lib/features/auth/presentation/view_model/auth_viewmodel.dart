import 'dart:io';

import 'package:fix_my_town/features/auth/domain/usecases/login_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/register_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/update_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/upload_photo_usecase.dart';
import 'package:fix_my_town/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewmodelProvider = NotifierProvider<AuthViewmodel, AuthState>(() {
  return AuthViewmodel();
});

class AuthViewmodel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final UploadPhotoUsecase _uploadPhotoUsecase;
  late final UpdateUsecase _updateUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _uploadPhotoUsecase = ref.read(uploadPhotoUsecaseProvider);
    _updateUsecase = ref.read(updateUsecaseProvider);
    return AuthState();
  }

  Future<String?> uploadPhoto(File photo) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _uploadPhotoUsecase(photo);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (url) {
        state = state.copyWith(
          status: AuthStatus.loaded,
          uploadedPhotoUrl: url,
        );
        return url;
      },
    );
  }

  Future<void> logout() async {
    await _logoutUsecase.call();
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      userEntity: null,
    );
  }

  Future<void> update({
    required String fullName,
    required String email,
    String? currentPassword,
    String? newPassword,
    String? profilePicture,
  }) async {
    print('═══════════════════════════════════');
    print('VIEWMODEL UPDATE');
    print('Full Name: $fullName');
    print('Email: $email');
    print('Current Password: ${currentPassword != null ? "***" : "null"}');
    print('New Password: ${newPassword != null ? "***" : "null"}');
    print('Profile Picture: $profilePicture');
    print('═══════════════════════════════════');
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    await Future.delayed(Duration(seconds: 2));
    final params = UpdateUsecaseParams(
      fullName: fullName,
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
      profilePicture: profilePicture,
    );
    final result = await _updateUsecase.call(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isUpdated) {
        state = state.copyWith(status: AuthStatus.updated);
      },
    );
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    await Future.delayed(Duration(seconds: 2));
    final params = RegisterUsecaseParams(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
    );
    final result = await _registerUsecase.call(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isRegisterd) {
        state = state.copyWith(status: AuthStatus.registered);
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    final params = LoginUsecaseParams(email: email, password: password);
    final result = await _loginUsecase.call(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          userEntity: user,
        );
      },
    );
  }
}
