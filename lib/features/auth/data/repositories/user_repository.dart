import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/auth/data/datasources/user_datasource.dart';
import 'package:fix_my_town/features/auth/data/models/user_hive_model.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';

class UserRepository implements IUserRepository {
  final IUserDatasource _datasource;

  UserRepository({required IUserDatasource datasource})
    : _datasource = datasource;

  @override
  Future<Either<Failure, bool>> createUser(UserEntity user) async {
    try {
      final model = UserHiveModel.fromEntity(user);
      final result = await _datasource.createUser(model);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to create user!"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser(String userId) async {
    try {
      final result = await _datasource.deleteUser(userId);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to delete user!"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      final models = await _datasource.getAllUsers();
      final entities = UserHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String userId) async {
    try {
      final model = await _datasource.getUserById(userId);
      if (model != null) {
        return Right(model.toEntity());
      }
      return Left(LocalDatabaseFailure(message: "User not found!"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUser(UserEntity user) async {
    try {
      final model = UserHiveModel.fromEntity(user);
      final result = await _datasource.updateUser(model);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to update user!"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
