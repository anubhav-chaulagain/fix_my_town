import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/issues/data/repositories/issues_repository.dart';
import 'package:fix_my_town/features/issues/domain/entities/issues_entity.dart';
import 'package:fix_my_town/features/issues/domain/repositories/issues_repository.dart';

class UpdateIssueParams extends Equatable {
  final IssuesEntity issue;
  final List<File> issueImages;

  const UpdateIssueParams({required this.issue, required this.issueImages});

  @override
  List<Object?> get props => [issue, issueImages];
}

final updateIssueUsecaseProvider = Provider<UpdateIssueUsecase>((ref) {
  return UpdateIssueUsecase(
    issueRepository: ref.read(issuesRepositoryProvider),
  );
});

class UpdateIssueUsecase implements UsecaseWithParams<bool, UpdateIssueParams> {
  final IIssueRepository _issueRepository;

  UpdateIssueUsecase({required IIssueRepository issueRepository})
    : _issueRepository = issueRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateIssueParams params) {
    return _issueRepository.updateIssue(params.issue, params.issueImages);
  }
}
