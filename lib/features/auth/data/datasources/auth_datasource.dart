import 'package:fix_my_town/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthDatasource {
  Future<List<AuthEntity>> getAllUsers();
  Future<AuthEntity> getUserById(String userId);
  Future<bool> createUser(AuthEntity user);
  Future<bool> updateUser(AuthEntity user);
  Future<bool> deleteUser(String userId);
}
