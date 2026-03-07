// issues_remote_datasource.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/features/issues/data/datasources/issues_datasource.dart';
import 'package:fix_my_town/features/issues/data/models/issues_api_model.dart';
import 'package:http_parser/http_parser.dart';

final issuesRemoteDatasourceProvider = Provider<IIssuesRemoteDataSource>((ref) {
  return IssuesRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class IssuesRemoteDatasource implements IIssuesRemoteDataSource {
  final ApiClient _apiClient;

  IssuesRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  // POST /api/issues (multipart - supports image uploads)
  @override
  Future<bool> createIssue(IssuesApiModel issue, List<File> issueImages) async {
    final formData = FormData.fromMap({
      if (issue.title != null) 'title': issue.title,
      if (issue.category != null) 'category': issue.category,
      if (issue.location != null) 'location': issue.location,
      if (issue.latitude != null) 'latitude': issue.latitude,
      if (issue.longitude != null) 'longitude': issue.longitude,
      if (issue.description != null) 'description': issue.description,
      if (issue.priority != null) 'priority': issue.priority,
      if (issueImages.isNotEmpty)
        'issueImages': issueImages.map((file) {
          final ext = file.path.split('.').last.toLowerCase();
          final mimeType = ext == 'png'
              ? 'image/png'
              : ext == 'gif'
              ? 'image/gif'
              : 'image/jpeg'; // default to jpeg for jpg/jpeg/heic etc.

          return MultipartFile.fromFileSync(
            file.path,
            filename: file.path.split('/').last,
            contentType: MediaType.parse(mimeType),
          );
        }).toList(),
    });

    final response = await _apiClient.uploadFile(
      ApiEndpoints.issues,
      formData: formData,
    );
    return response.statusCode == 201;
  }

  // GET /api/issues
  @override
  Future<List<IssuesApiModel>> getAllIssues() async {
    final response = await _apiClient.get(ApiEndpoints.issues);
    final data = response.data['data'] as List;
    return data.map((json) => IssuesApiModel.fromJson(json)).toList();
  }

  // GET /api/issues/:id
  @override
  Future<IssuesApiModel?> getIssueById(String issueId) async {
    final response = await _apiClient.get('${ApiEndpoints.issues}/$issueId');
    final data = response.data['data'];
    return IssuesApiModel.fromJson(data);
  }

  // PUT /api/issues/:id (multipart - supports image uploads)
  @override
  Future<bool> updateIssue(IssuesApiModel issue, List<File> issueImages) async {
    final formData = FormData.fromMap({
      if (issue.title != null) 'title': issue.title,
      if (issue.category != null) 'category': issue.category,
      if (issue.location != null) 'location': issue.location,
      if (issue.latitude != null) 'latitude': issue.latitude,
      if (issue.longitude != null) 'longitude': issue.longitude,
      if (issue.description != null) 'description': issue.description,
      if (issue.priority != null) 'priority': issue.priority,
      if (issueImages.isNotEmpty)
        'issueImages': issueImages.map((file) {
          final ext = file.path.split('.').last.toLowerCase();
          final mimeType = ext == 'png'
              ? 'image/png'
              : ext == 'gif'
              ? 'image/gif'
              : 'image/jpeg'; // default to jpeg for jpg/jpeg/heic etc.

          return MultipartFile.fromFileSync(
            file.path,
            filename: file.path.split('/').last,
            contentType: MediaType.parse(mimeType),
          );
        }).toList(),
    });

    final response = await _apiClient.uploadFile(
      '${ApiEndpoints.issues}/${issue.id}',
      formData: formData,
      options: Options(method: 'PUT'),
    );
    return response.statusCode == 200;
  }

  // DELETE /api/issues/:id
  @override
  Future<bool> deleteIssue(String issueId) async {
    final response = await _apiClient.delete('${ApiEndpoints.issues}/$issueId');
    return response.statusCode == 200;
  }

  // GET /api/issues?status=xxx
  @override
  Future<List<IssuesApiModel>> getIssuesByStatus(String status) async {
    final response = await _apiClient.get(
      ApiEndpoints.issues,
      queryParameters: {'status': status},
    );
    final data = response.data['data'] as List;
    return data.map((json) => IssuesApiModel.fromJson(json)).toList();
  }

  // GET /api/issues?category=xxx
  @override
  Future<List<IssuesApiModel>> getIssuesByCategory(String category) async {
    final response = await _apiClient.get(
      ApiEndpoints.issues,
      queryParameters: {'category': category},
    );
    final data = response.data['data'] as List;
    return data.map((json) => IssuesApiModel.fromJson(json)).toList();
  }

  // GET /api/issues/my-issues
  @override
  Future<List<IssuesApiModel>> getIssuesByReportedBy(String reportedBy) async {
    final response = await _apiClient.get('${ApiEndpoints.issues}/my-issues');
    final data = response.data['data'] as List;
    return data.map((json) => IssuesApiModel.fromJson(json)).toList();
  }

  // GET /api/issues/my-assigned
  @override
  Future<List<IssuesApiModel>> getMyAssignedIssues() async {
    final response = await _apiClient.get('${ApiEndpoints.issues}/my-assigned');
    final data = response.data['data'] as List;
    return data.map((json) => IssuesApiModel.fromJson(json)).toList();
  }

  // GET /api/issues/my-recent
  @override
  Future<List<IssuesApiModel>> getMyRecentIssues() async {
    final response = await _apiClient.get('${ApiEndpoints.issues}/my-recent');
    final data = response.data['data'] as List;
    return data.map((json) => IssuesApiModel.fromJson(json)).toList();
  }

  // GET /api/issues/unassigned
  @override
  Future<List<IssuesApiModel>> getUnassignedIssues() async {
    final response = await _apiClient.get('${ApiEndpoints.issues}/unassigned');
    final data = response.data['data'] as List;
    return data.map((json) => IssuesApiModel.fromJson(json)).toList();
  }

  // PATCH /api/issues/:id/status
  @override
  Future<bool> updateIssueStatus(String issueId, String status) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.issues}/$issueId/status',
      data: {'status': status},
    );
    return response.statusCode == 200;
  }

  // PATCH /api/issues/:id/assign
  @override
  Future<bool> assignIssue(String issueId, String assignedTo) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.issues}/$issueId/assign',
      data: {'assignedTo': assignedTo},
    );
    return response.statusCode == 200;
  }

  // PATCH /api/issues/:id/resolve
  @override
  Future<bool> resolveIssue(String issueId, String remarks) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.issues}/$issueId/resolve',
      data: {'remarks': remarks},
    );
    return response.statusCode == 200;
  }
}
