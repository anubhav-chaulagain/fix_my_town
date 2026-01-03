import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/auth/data/datasources/local/user_local_datasource.dart';
import 'package:fix_my_town/features/auth/data/datasources/user_datasource.dart';
import 'package:fix_my_town/features/auth/data/models/user_hive_model.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return UserRepository(datasource: ref.read(userLocalDatasourceProvider));
});

class UserRepository implements IUserRepository {
  final IUserDatasource _datasource;

  UserRepository({required IUserDatasource datasource})
    : _datasource = datasource;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final model = await _datasource.login(email, password);
      if (model != null) {
        return Right(model.toEntity());
      }
      return const Left(LocalDatabaseFailure(message: "Failed to login user!"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _datasource.logout();
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to logout user!"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(UserEntity user) async {
    try {
      final model = UserHiveModel.fromEntity(user);
      final result = await _datasource.register(model);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to register user!"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, bool>> createUser(UserEntity user) async {
  //   try {
  //     final model = UserHiveModel.fromEntity(user);
  //     final result = await _datasource.createUser(model);
  //     if (result) {
  //       return const Right(true);
  //     }
  //     return const Left(
  //       LocalDatabaseFailure(message: "Failed to create user!"),
  //     );
  //   } catch (e) {
  //     return Left(LocalDatabaseFailure(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, bool>> deleteUser(String userId) async {
  //   try {
  //     final result = await _datasource.deleteUser(userId);
  //     if (result) {
  //       return const Right(true);
  //     }
  //     return const Left(
  //       LocalDatabaseFailure(message: "Failed to delete user!"),
  //     );
  //   } catch (e) {
  //     return Left(LocalDatabaseFailure(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
  //   try {
  //     final models = await _datasource.getAllUsers();
  //     final entities = UserHiveModel.toEntityList(models);
  //     return Right(entities);
  //   } catch (e) {
  //     return Left(LocalDatabaseFailure(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, UserEntity>> getUserById(String userId) async {
  //   try {
  //     final model = await _datasource.getUserById(userId);
  //     if (model != null) {
  //       return Right(model.toEntity());
  //     }
  //     return Left(LocalDatabaseFailure(message: "User not found!"));
  //   } catch (e) {
  //     return Left(LocalDatabaseFailure(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, bool>> updateUser(UserEntity user) async {
  //   try {
  //     final model = UserHiveModel.fromEntity(user);
  //     final result = await _datasource.updateUser(model);
  //     if (result) {
  //       return const Right(true);
  //     }
  //     return const Left(
  //       LocalDatabaseFailure(message: "Failed to update user!"),
  //     );
  //   } catch (e) {
  //     return Left(LocalDatabaseFailure(message: e.toString()));
  //   }
  // }
}
