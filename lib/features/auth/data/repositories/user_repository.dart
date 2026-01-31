import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/core/services/connectivity/network_info.dart';
import 'package:fix_my_town/features/auth/data/datasources/local/user_local_datasource.dart';
import 'package:fix_my_town/features/auth/data/datasources/remote/user_remote_datasource.dart';
import 'package:fix_my_town/features/auth/data/datasources/user_datasource.dart';
import 'package:fix_my_town/features/auth/data/models/user_api_model.dart';
import 'package:fix_my_town/features/auth/data/models/user_hive_model.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final networkInfo = ref.read(networkInfoProvider);
  final remoteDatasource = ref.read(userRemoteDatasourceProvider);
  return UserRepository(
    userLocalDatasource: ref.read(userLocalDatasourceProvider),
    userRemoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class UserRepository implements IUserRepository {
  final IUserLocalDatasource _userLocalDatasource;
  final IUserRemoteDatasource _userRemoteDatasource;
  final NetworkInfo _networkInfo;

  UserRepository({
    required IUserLocalDatasource userLocalDatasource,
    required IUserRemoteDatasource userRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _userLocalDatasource = userLocalDatasource,
       _userRemoteDatasource = userRemoteDatasource,
       _networkInfo = networkInfo;
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
    if (await _networkInfo.isConnected) {
      try {
        final result = await _userRemoteDatasource.login(email, password);
        if (result != null) {
          final entity = result.toEntity();
          return Right(entity);
        }
        return Left(ApiFailure(message: "Invalid credentials"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(message: e.response?.data["message"] ?? "Login Failed"),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _userLocalDatasource.login(email, password);

        if (model != null) {
          final entity = model.toEntity();
          return Right(entity);
        }

        return Left(LocalDatabaseFailure(message: "User not found"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _userLocalDatasource.logout();
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
    if (await _networkInfo.isConnected) {
      try {
        final userModel = UserApiModel.fromEntity(user);
        await _userRemoteDatasource.register(userModel);
        return Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Registration failed",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = UserHiveModel.fromEntity(user);
        final result = await _userLocalDatasource.register(model);
        if (result) return Right(true);
        return Left(LocalDatabaseFailure(message: "Failed to register user"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(File photo) async {
    if (await _networkInfo.isConnected) {
      try {
        final url = await _userRemoteDatasource.uploadPhoto(photo);
        return Right(url);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
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
