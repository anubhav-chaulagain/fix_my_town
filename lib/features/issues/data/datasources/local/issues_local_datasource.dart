import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fix_my_town/core/services/hive/hive_service.dart';
import 'package:fix_my_town/features/issues/data/datasources/issues_datasource.dart';
import 'package:fix_my_town/features/issues/data/models/issues_hive_model.dart';

final issuesLocalDatasourceProvider = Provider<IssuesLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return IssuesLocalDatasource(hiveService: hiveService);
});

class IssuesLocalDatasource implements IIssuesLocalDataSource {
  final HiveService _hiveService;

  IssuesLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> createIssue(IssuesHiveModel issue) async {
    try {
      await _hiveService.createIssue(issue);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteIssue(String issueId) async {
    try {
      await _hiveService.deleteIssue(issueId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<IssuesHiveModel>> getAllIssues() async {
    try {
      return _hiveService.getAllIssues();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<IssuesHiveModel?> getIssueById(String issueId) async {
    try {
      return _hiveService.getIssueById(issueId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateIssue(IssuesHiveModel issue) async {
    try {
      await _hiveService.updateIssue(issue);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<IssuesHiveModel>> getIssuesByStatus(String status) async {
    try {
      return _hiveService.getIssuesByStatus(status);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<IssuesHiveModel>> getIssuesByCategory(String category) async {
    try {
      return _hiveService.getIssuesByCategory(category);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<IssuesHiveModel>> getIssuesByReportedBy(String reportedBy) async {
    try {
      return _hiveService.getIssuesByReportedBy(reportedBy);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<IssuesHiveModel>> getIssuesByPriority(String priority) async {
    try {
      return _hiveService.getIssuesByPriority(priority);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<IssuesHiveModel>> getIssuesByAssignedTo(String assignedTo) async {
    try {
      return _hiveService.getIssuesByAssignedTo(assignedTo);
    } catch (e) {
      return [];
    }
  }
}
