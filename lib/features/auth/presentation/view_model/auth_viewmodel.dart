import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:fix_my_town/features/auth/domain/usecases/create_user_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/get_all_users_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/get_user_by_id_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:fix_my_town/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthViewmodel extends Notifier<AuthState> {
  late final CreateUserUsecase _createUserUsecase;
  late final DeleteUserUsecase _deleteUserUsecase;
  late final GetAllUsersUsecase _getAllUsersUsecase;
  late final GetUserByIdUsercase _getUserByIdUsercase;
  late final UpdateUserUsecase _updateUserUsecase;

  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> getAllUsers() async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _getAllUsersUsecase();

    result.fold(
      (failure) => state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (users) => state.copyWith(status: AuthStatus.loaded, users: users),
    );
  }

  Future<void> createUser(
    String email,
    String password,
    String fullname,
    UserRole? role,
  ) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _createUserUsecase(
      CreateUserUsecaseParams(
        email: email,
        password: password,
        fullname: fullname,
        role: role ?? UserRole.citizen,
      ),
    );

    result.fold(
      (left) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: left.message,
        );
      },
      (right) {
        state = state.copyWith(status: AuthStatus.loaded);
      },
    );
  }

  Future<void> updateUser({
    required String userId,
    required String email,
    required String password,
    required String fullname,
    required UserRole role,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _updateUserUsecase(
      UpdateUserUsecaseParams(
        email: email,
        password: password,
        fullname: fullname,
        role: role,
        userId: userId,
      ),
    );
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (__) {
        state.copyWith(status: AuthStatus.updated);
        getAllUsers();
      },
    );
  }

  Future<void> deleteUser(String userId) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _deleteUserUsecase(
      DeleteUserUsecaseParams(userId: userId),
    );
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (__) {
        state = state.copyWith(status: AuthStatus.deleted);
        getAllUsers();
      },
    );
  }

  // Future<void> getUserById(String userId) async {
  //   state = state.copyWith(status: AuthStatus.loading);
  //   final result = await _getUserByIdUsercase(
  //     GetUserByIdUsercaseParams(userId: userId),
  //   );
  //   result.fold(
  //     (failure) => state = state.copyWith(
  //       status: AuthStatus.error,
  //       errorMessage: failure.message,
  //     ),
  //     (user) {
  //       state = state.copyWith(status: AuthStatus.loaded);
  //     },
  //   );
  // }
}
