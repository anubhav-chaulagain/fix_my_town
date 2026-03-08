import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:fix_my_town/features/auth/domain/usecases/login_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/register_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/update_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/upload_photo_usecase.dart';
import 'package:fix_my_town/features/auth/presentation/state/auth_state.dart';
import 'package:fix_my_town/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockUploadPhotoUsecase extends Mock implements UploadPhotoUsecase {}

class MockUpdateUsecase extends Mock implements UpdateUsecase {}

ProviderContainer makeAuthContainer({
  required MockLoginUsecase loginUsecase,
  required MockRegisterUsecase registerUsecase,
  required MockLogoutUsecase logoutUsecase,
  required MockUploadPhotoUsecase uploadPhotoUsecase,
  required MockUpdateUsecase updateUsecase,
}) {
  return ProviderContainer(
    overrides: [
      loginUsecaseProvider.overrideWithValue(loginUsecase),
      registerUsecaseProvider.overrideWithValue(registerUsecase),
      logoutUsecaseProvider.overrideWithValue(logoutUsecase),
      uploadPhotoUsecaseProvider.overrideWithValue(uploadPhotoUsecase),
      updateUsecaseProvider.overrideWithValue(updateUsecase),
    ],
  );
}

void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockUploadPhotoUsecase mockUploadPhotoUsecase;
  late MockUpdateUsecase mockUpdateUsecase;
  late ProviderContainer container;

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterUsecase = MockRegisterUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockUploadPhotoUsecase = MockUploadPhotoUsecase();
    mockUpdateUsecase = MockUpdateUsecase();

    container = makeAuthContainer(
      loginUsecase: mockLoginUsecase,
      registerUsecase: mockRegisterUsecase,
      logoutUsecase: mockLogoutUsecase,
      uploadPhotoUsecase: mockUploadPhotoUsecase,
      updateUsecase: mockUpdateUsecase,
    );

    registerFallbackValue(LoginUsecaseParams(email: '', password: ''));
    registerFallbackValue(
      RegisterUsecaseParams(fullName: '', email: '', password: '', role: ''),
    );
  });

  tearDown(() => container.dispose());

  group("AuthViewmodel", () {
    test("login success → state becomes authenticated with user", () async {
      final fakeUser = UserEntity(
        fullName: "Anubhav Chaulagain",
        email: "ac@gmail.com",
      );

      when(
        () => mockLoginUsecase.call(any()),
      ).thenAnswer((_) async => Right(fakeUser));

      await container
          .read(authViewmodelProvider.notifier)
          .login(email: "ac@gmail.com", password: "password123");

      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.userEntity, fakeUser);
    });

    test("login failure → state becomes error with message", () async {
      when(() => mockLoginUsecase.call(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: "Invalid credentials")),
      );

      await container
          .read(authViewmodelProvider.notifier)
          .login(email: "wrong@gmail.com", password: "wrongpass");

      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, "Invalid credentials");
    });

    test("register success → state becomes registered", () async {
      when(
        () => mockRegisterUsecase.call(any()),
      ).thenAnswer((_) async => const Right(true));

      await container
          .read(authViewmodelProvider.notifier)
          .register(
            fullName: "Anubhav Chaulagain",
            email: "ac@gmail.com",
            password: "password123",
            role: "user",
          );

      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.registered);
    });

    test("register failure → state becomes error with message", () async {
      when(() => mockRegisterUsecase.call(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: "Email already exists")),
      );

      await container
          .read(authViewmodelProvider.notifier)
          .register(
            fullName: "Anubhav Chaulagain",
            email: "ac@gmail.com",
            password: "password123",
            role: "user",
          );

      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, "Email already exists");
    });

    test(
      "logout → state becomes unauthenticated and user is cleared",
      () async {
        when(
          () => mockLogoutUsecase.call(),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        await container.read(authViewmodelProvider.notifier).logout();

        final state = container.read(authViewmodelProvider);
        expect(state.status, AuthStatus.unauthenticated);
        expect(state.userEntity, isNull);
      },
    );
  });
}
