import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/issues/domain/entities/issues_entity.dart';

abstract interface class IIssueRepository {
  // Public/Citizen routes
  Future<Either<Failure, bool>> createIssue(
    IssuesEntity issue,
    List<File> issueImages,
  );
  Future<Either<Failure, List<IssuesEntity>>> getAllIssues();
  Future<Either<Failure, List<IssuesEntity>>> getUserIssues();
  Future<Either<Failure, List<IssuesEntity>>> getMyRecentIssues();
  Future<Either<Failure, List<IssuesEntity>>> getMyAssignedIssues();
  Future<Either<Failure, IssuesEntity>> getIssueById(String issueId);
  Future<Either<Failure, bool>> updateIssue(
    IssuesEntity issue,
    List<File> issueImages,
  );
  Future<Either<Failure, bool>> deleteIssue(String issueId);

  // Authority routes (for status management)
  Future<Either<Failure, bool>> updateIssueStatus(
    String issueId,
    String status,
  );
  Future<Either<Failure, bool>> assignIssue(String issueId, String assigneeId);
  Future<Either<Failure, bool>> resolveIssue(String issueId);
}
