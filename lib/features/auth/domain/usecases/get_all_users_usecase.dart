import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';

class GetAllUsersUsecase implements UsecaseWithoutParams<List<UserEntity>> {
  final IUserRepository _userRepository;
  GetAllUsersUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;
  @override
  Future<Either<Failure, List<UserEntity>>> call() {
    return _userRepository.getAllUsers();
  }
}
