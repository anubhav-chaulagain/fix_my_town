import 'package:fix_my_town/features/auth/data/models/user_hive_model.dart';

abstract interface class IUserDatasource {
  Future<List<UserHiveModel>> getAllUsers();
  Future<UserHiveModel?> getUserById(String userId);
  Future<bool> createUser(UserHiveModel user);
  Future<bool> updateUser(UserHiveModel user);
  Future<bool> deleteUser(String userId);
}
