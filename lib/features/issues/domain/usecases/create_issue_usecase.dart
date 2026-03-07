// create_issue_usecase.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/issues/data/repositories/issues_repository.dart';
import 'package:fix_my_town/features/issues/domain/entities/issues_entity.dart';
import 'package:fix_my_town/features/issues/domain/repositories/issues_repository.dart';

class CreateIssueParams extends Equatable {
  final String title;
  final String category;
  final String location;
  final String latitude;
  final String longitude;
  final String description;
  final String priority;
  final List<File> issueImages;

  const CreateIssueParams({
    required this.title,
    required this.category,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.priority,
    required this.issueImages,
  });

  @override
  List<Object?> get props => [
    title,
    category,
    location,
    latitude,
    longitude,
    description,
    priority,
    issueImages,
  ];
}

final createIssueUsecaseProvider = Provider<CreateIssueUsecase>((ref) {
  return CreateIssueUsecase(
    issueRepository: ref.read(issuesRepositoryProvider),
  );
});

class CreateIssueUsecase implements UsecaseWithParams<bool, CreateIssueParams> {
  final IIssueRepository _issueRepository;

  CreateIssueUsecase({required IIssueRepository issueRepository})
    : _issueRepository = issueRepository;

  @override
  Future<Either<Failure, bool>> call(CreateIssueParams params) {
    final issueEntity = IssuesEntity(
      title: params.title,
      category: params.category,
      location: params.location,
      latitude: params.latitude,
      longitude: params.longitude,
      description: params.description,
      priority: params.priority,
    );
    return _issueRepository.createIssue(issueEntity, params.issueImages);
  }
}
