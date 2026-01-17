import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/features/auth/data/datasources/user_datasource.dart';
import 'package:fix_my_town/features/auth/data/models/user_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// provider
final userRemoteDatasourceProvider = Provider<UserRemoteDatasource>((ref) {
  final userSessionService = ref.read(userSessionServiceProvider);
  return UserRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: userSessionService,
  );
});

class UserRemoteDatasource implements IUserRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  UserRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<UserApiModel?> getCurrentUser(String userId) {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<UserApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.userLogin,
      data: {"email": email, "password": password},
    );

    if (response.data["success"] == true) {
      final data = response.data["data"] as Map<String, dynamic>;
      final user = UserApiModel.fromJson(data);
      // info: Save user session
      await _userSessionService.saveUserSession(
        userId: user.userId!,
        email: user.email,
        fullname: user.fullName,
        role: user.role,
      );
      return user;
    }
    return null;
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<UserApiModel> register(UserApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.userRegister,
      data: user.toJson(),
    );

    if (response.data["success"] == true) {
      final data = response.data["data"] as Map<String, dynamic>;
      final resistedUser = UserApiModel.fromJson(data);
      return resistedUser;
    }

    return user;
  }
}
