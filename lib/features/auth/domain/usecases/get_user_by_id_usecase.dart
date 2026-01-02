import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';

class DeleteUserUsecaseParams extends Equatable {
  final String userId;
  const DeleteUserUsecaseParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class DeleteUserUsecase
    implements UsecaseWithParams<void, DeleteUserUsecaseParams> {
  final IUserRepository _userRepository;
  DeleteUserUsecase(this._userRepository);
  @override
  Future<Either<Failure, void>> call(DeleteUserUsecaseParams params) {
    return _userRepository.deleteUser(params.userId);
  }
}
