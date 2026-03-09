import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/issues/data/datasources/issues_datasource.dart';
import 'package:fix_my_town/features/issues/data/datasources/local/issues_local_datasource.dart';
import 'package:fix_my_town/features/issues/data/datasources/remote/issues_remote_datasource.dart';
import 'package:fix_my_town/features/issues/data/models/issues_api_model.dart';
import 'package:fix_my_town/features/issues/domain/entities/issues_entity.dart';
import 'package:fix_my_town/features/issues/domain/repositories/issues_repository.dart';

final issuesRepositoryProvider = Provider<IIssueRepository>((ref) {
  return IssuesRepository(
    issuesLocalDatasource: ref.read(issuesLocalDatasourceProvider),
    issuesRemoteDatasource: ref.read(issuesRemoteDatasourceProvider),
  );
});

class IssuesRepository implements IIssueRepository {
  final IIssuesLocalDataSource _localDataSource;
  final IIssuesRemoteDataSource _remoteDataSource;

  IssuesRepository({
    required IIssuesLocalDataSource issuesLocalDatasource,
    required IIssuesRemoteDataSource issuesRemoteDatasource,
  }) : _localDataSource = issuesLocalDatasource,
       _remoteDataSource = issuesRemoteDatasource;

  @override
  Future<Either<Failure, bool>> createIssue(
    IssuesEntity issue,
    List<File> issueImages,
  ) async {
    try {
      final apiModel = IssuesApiModel.fromEntity(issue);
      final result = await _remoteDataSource.createIssue(apiModel, issueImages);
      if (result) return const Right(true);
      return const Left(ApiFailure(message: "Failed to create issue"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IssuesEntity>>> getAllIssues() async {
    try {
      final models = await _remoteDataSource.getAllIssues();
      return Right(IssuesApiModel.toEntityList(models));
    } catch (e) {
      try {
        final localModels = await _localDataSource.getAllIssues();
        return Right(localModels.map((m) => m.toEntity()).toList());
      } catch (_) {
        return Left(ApiFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, IssuesEntity>> getIssueById(String issueId) async {
    try {
      final model = await _remoteDataSource.getIssueById(issueId);
      if (model != null) return Right(model.toEntity());
      return const Left(ApiFailure(message: "Issue not found"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IssuesEntity>>> getUserIssues() async {
    try {
      final models = await _remoteDataSource.getUnassignedIssues();
      return Right(IssuesApiModel.toEntityList(models));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IssuesEntity>>> getMyRecentIssues() async {
    try {
      final models = await _remoteDataSource.getMyRecentIssues();
      return Right(IssuesApiModel.toEntityList(models));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IssuesEntity>>> getMyAssignedIssues() async {
    try {
      final models = await _remoteDataSource.getMyAssignedIssues();
      return Right(IssuesApiModel.toEntityList(models));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateIssue(
    IssuesEntity issue,
    List<File> issueImages,
  ) async {
    try {
      final apiModel = IssuesApiModel.fromEntity(issue);
      final result = await _remoteDataSource.updateIssue(apiModel, issueImages);
      if (result) return const Right(true);
      return const Left(ApiFailure(message: "Failed to update issue"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateIssueStatus(
    String issueId,
    String status,
  ) async {
    try {
      final result = await _remoteDataSource.updateIssueStatus(issueId, status);
      if (result) return const Right(true);
      return const Left(ApiFailure(message: "Failed to update status"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> assignIssue(
    String issueId,
    String assigneeId,
  ) async {
    try {
      final result = await _remoteDataSource.assignIssue(issueId, assigneeId);
      if (result) return const Right(true);
      return const Left(ApiFailure(message: "Failed to assign issue"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resolveIssue(String issueId) async {
    try {
      final result = await _remoteDataSource.resolveIssue(issueId, '');
      if (result) return const Right(true);
      return const Left(ApiFailure(message: "Failed to resolve issue"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteIssue(String issueId) async {
    try {
      final result = await _remoteDataSource.deleteIssue(issueId);
      if (result) return const Right(true);
      return const Left(ApiFailure(message: "Failed to delete issue"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
