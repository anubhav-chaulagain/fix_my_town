import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/core/services/storage/token_service.dart';
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
    tokenService: ref.read(tokenServiceProvider),
  );
});

class UserRemoteDatasource implements IUserRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  UserRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  @override
  Future<String> uploadPhoto(File photo) async {
    final fileName = photo.path.split('/').last;
    final formData = FormData.fromMap({
      'profilePicture': await MultipartFile.fromFile(
        photo.path,
        filename: fileName,
      ),
    });
    // Get token from token service
    final token = await _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.userUploadPhoto,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data['data'];
  }

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

  @override
  Future<UserApiModel> update(UserApiModel user) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.userUpdate,
        data: user.toJsonForUpdate(),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.data["success"] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final updatedUser = UserApiModel.fromJson(data);

        // Update seesion with new data
        await _userSessionService.saveUserSession(
          userId: updatedUser.userId!,
          email: updatedUser.email,
          fullname: updatedUser.fullName,
          role: updatedUser.role,
          profileImage: updatedUser.profilePicture,
        );
        return updatedUser;
      }
      throw Exception('Update failed: ${response.data["message"]}');
    } catch (e) {
      print('═══════════════════════════════════');
      print('UPDATE ERROR: $e');
      print('Error Type: ${e.runtimeType}');
      if (e is DioException) {
        print('DioException Type: ${e.type}');
        print('DioException Message: ${e.message}');
        print('Response Data: ${e.response?.data}');
      }
      print('═══════════════════════════════════');
      rethrow;
    }
  }
}
