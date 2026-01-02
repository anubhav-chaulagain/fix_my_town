import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, List<AuthEntity>>> getAllUsers();
  Future<Either<Failure, AuthEntity>> getUserById(String userId);
  Future<Either<Failure, bool>> createUser(AuthEntity user);
  Future<Either<Failure, bool>> updateUser(AuthEntity user);
  Future<Either<Failure, bool>> deleteUser(String userId);
}
