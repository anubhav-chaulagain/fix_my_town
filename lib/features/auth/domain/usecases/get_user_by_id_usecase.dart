import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';

class GetUserByIdUsercaseParams extends Equatable {
  final String userId;
  const GetUserByIdUsercaseParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetUserByIdUsercase
    implements UsecaseWithParams<void, GetUserByIdUsercaseParams> {
  final IUserRepository _userRepository;
  GetUserByIdUsercase(this._userRepository);
  @override
  Future<Either<Failure, void>> call(GetUserByIdUsercaseParams params) {
    return _userRepository.deleteUser(params.userId);
  }
}
