import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:fix_my_town/features/auth/data/repositories/user_repository.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// logout usecase provider
final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  return LogoutUsecase(userRepository: ref.read(userRepositoryProvider));
});

class LogoutUsecase implements UsecaseWithoutParams<void> {
  final IUserRepository _userRepository;
  LogoutUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call() {
    return _userRepository.logout();
  }
}
