import 'dart:io';

import 'package:fix_my_town/features/issues/data/models/issues_api_model.dart';
import 'package:fix_my_town/features/issues/data/models/issues_hive_model.dart';

abstract interface class IIssuesLocalDataSource {
  Future<List<IssuesHiveModel>> getAllIssues();
  Future<IssuesHiveModel?> getIssueById(String issueId);
  Future<bool> createIssue(IssuesHiveModel issue);
  Future<bool> updateIssue(IssuesHiveModel issue);
  Future<bool> deleteIssue(String issueId);
  Future<List<IssuesHiveModel>> getIssuesByStatus(String status);
  Future<List<IssuesHiveModel>> getIssuesByCategory(String category);
  Future<List<IssuesHiveModel>> getIssuesByReportedBy(String reportedBy);
  Future<List<IssuesHiveModel>> getIssuesByPriority(String priority);
  Future<List<IssuesHiveModel>> getIssuesByAssignedTo(String assignedTo);
}

abstract interface class IIssuesRemoteDataSource {
  Future<List<IssuesApiModel>> getAllIssues();
  Future<IssuesApiModel?> getIssueById(String issueId);
  Future<bool> createIssue(IssuesApiModel issue, List<File> issueImages);
  Future<bool> updateIssue(IssuesApiModel issue, List<File> issueImages);
  Future<bool> deleteIssue(String issueId);
  Future<List<IssuesApiModel>> getIssuesByStatus(String status);
  Future<List<IssuesApiModel>> getIssuesByCategory(String category);
  Future<List<IssuesApiModel>> getIssuesByReportedBy(String reportedBy);
  Future<List<IssuesApiModel>> getMyAssignedIssues();
  Future<List<IssuesApiModel>> getMyRecentIssues();
  Future<List<IssuesApiModel>> getUnassignedIssues();
  Future<bool> updateIssueStatus(String issueId, String status);
  Future<bool> assignIssue(String issueId, String assignedTo);
  Future<bool> resolveIssue(String issueId, String remarks);
}
