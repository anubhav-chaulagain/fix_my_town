import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService(prefs: ref.read(sharedPreferencesProvider));
});

class UserSessionService {
  late final SharedPreferences _prefs;

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  @protected
  UserSessionService.forTesting();

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserFullname = 'user_fullname';
  static const String _keyRole = 'user_role';
  static const String _keyProfileImage = 'user_profile_image';

  Future<void> saveUserSession({
    required String email,
    String? role,
    required String? fullname,
    String? profileImage,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyRole, "$role");
    await _prefs.setString(_keyUserFullname, fullname ?? "");
    if (profileImage != null) {
      await _prefs.setString(_keyProfileImage, profileImage);
    }
  }

  Future<void> clearUserSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyRole);
    await _prefs.remove(_keyUserFullname);
    await _prefs.remove(_keyProfileImage);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  String? getUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  String? getFullname() {
    return _prefs.getString(_keyUserFullname);
  }

  String? getRole() {
    return _prefs.getString(_keyRole);
  }

  String? getProfileImage() {
    return _prefs.getString(_keyProfileImage);
  }
}
