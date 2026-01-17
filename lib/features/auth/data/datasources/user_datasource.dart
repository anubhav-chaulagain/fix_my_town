import 'package:fix_my_town/features/auth/data/models/user_api_model.dart';
import 'package:fix_my_town/features/auth/data/models/user_hive_model.dart';

abstract interface class IUserLocalDatasource {
  Future<bool> register(UserHiveModel user);
  Future<UserHiveModel?> login(String email, String password);
  Future<UserHiveModel?> getCurrentUser();
  Future<bool> logout();

  Future<bool> ifEmailExists(String email);

  // Future<List<UserHiveModel>> getAllUsers();
  // Future<UserHiveModel?> getUserById(String userId);
  // Future<bool> createUser(UserHiveModel user);
  // Future<bool> updateUser(UserHiveModel user);
  // Future<bool> deleteUser(String userId);
}

abstract interface class IUserRemoteDatasource {
  Future<UserApiModel> register(UserApiModel user);
  Future<UserApiModel?> login(String email, String password);
  Future<UserApiModel?> getCurrentUser(String userId);
  Future<bool> logout();
}
