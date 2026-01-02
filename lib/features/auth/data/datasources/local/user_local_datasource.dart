import 'package:fix_my_town/core/services/hive/hive_service.dart';
import 'package:fix_my_town/features/auth/data/datasources/user_datasource.dart';
import 'package:fix_my_town/features/auth/data/models/user_hive_model.dart';

class AuthLocalDatasource implements IUserDatasource {
  final HiveService _hiveService;

  AuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> createUser(UserHiveModel user) async {
    try {
      await _hiveService.createUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteUser(String userId) async {
    try {
      await _hiveService.deleteUser(userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<UserHiveModel>> getAllUsers() async {
    try {
      return _hiveService.getAllUsers();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<UserHiveModel?> getUserById(String userId) async {
    try {
      return _hiveService.getUserById(userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateUser(UserHiveModel user) async {
    try {
      await _hiveService.updateUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }
}
