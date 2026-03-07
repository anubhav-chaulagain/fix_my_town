import 'package:fix_my_town/core/services/hive/hive_service.dart';
import 'package:fix_my_town/core/services/storage/token_service.dart';
import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/features/auth/data/datasources/user_datasource.dart';
import 'package:fix_my_town/features/auth/data/models/user_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  return AuthLocalDatasource(
    hiveService: ref.read(hiveServiceProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthLocalDatasource implements IUserLocalDatasource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  @override
  Future<UserHiveModel?> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<UserHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.login(email, password);
      if (user != null) {
        await _userSessionService.saveUserSession(
          email: user.email,
          fullname: user.fullname!,
          role: user.role,
          profileImage: user.profilePicture,
        );
      }
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _hiveService.logout();
      await _userSessionService.clearUserSession();
      await _tokenService.removeToken(); // ← clears JWT from secure storage
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> register(UserHiveModel user) async {
    try {
      await _hiveService.register(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> ifEmailExists(String email) {
    try {
      return _hiveService.ifEmailExists(email);
    } catch (e) {
      return Future.value(false);
    }
  }
}
