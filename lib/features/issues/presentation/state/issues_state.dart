import 'package:equatable/equatable.dart';
import 'package:fix_my_town/features/issues/domain/entities/issues_entity.dart';

enum IssuesStatus {
  initial,
  loading,
  loaded,
  error,
  created,
  updated,
  deleted,
  assigned,
  resolved,
}

class IssuesState extends Equatable {
  final IssuesStatus status;
  final List<IssuesEntity> issues;
  final List<IssuesEntity> userIssues;
  final List<IssuesEntity> recentIssues;
  final List<IssuesEntity> assignedIssues;
  final IssuesEntity? selectedIssue;
  final String? errorMessage;

  const IssuesState({
    this.status = IssuesStatus.initial,
    this.issues = const [],
    this.userIssues = const [],
    this.recentIssues = const [],
    this.assignedIssues = const [],
    this.selectedIssue,
    this.errorMessage,
  });

  IssuesState copyWith({
    IssuesStatus? status,
    List<IssuesEntity>? issues,
    List<IssuesEntity>? userIssues,
    List<IssuesEntity>? recentIssues,
    List<IssuesEntity>? assignedIssues,
    IssuesEntity? selectedIssue,
    String? errorMessage,
  }) {
    return IssuesState(
      status: status ?? this.status,
      issues: issues ?? this.issues,
      userIssues: userIssues ?? this.userIssues,
      recentIssues: recentIssues ?? this.recentIssues,
      assignedIssues: assignedIssues ?? this.assignedIssues,
      selectedIssue: selectedIssue ?? this.selectedIssue,
      errorMessage:
          errorMessage ?? this.errorMessage, // matches category pattern
    );
  }

  @override
  List<Object?> get props => [
    status,
    issues,
    userIssues,
    recentIssues,
    assignedIssues,
    selectedIssue,
    errorMessage,
  ];
}
