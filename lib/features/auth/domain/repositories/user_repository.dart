import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, bool>> register(UserEntity user);
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, String>> uploadPhoto(File photo);
  Future<Either<Failure, bool>> update(UserEntity user);
}
