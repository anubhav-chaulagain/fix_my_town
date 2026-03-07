import 'package:equatable/equatable.dart';

class IssuesEntity extends Equatable {
  final String? issueId;
  final String? title;
  final String? category;
  final String? location;
  final String? latitude;
  final String? longitude;
  final String? description;
  final String? issueImages;
  final String? status;
  final String? priority;
  final String? reportedBy;
  final String? assignedTo;
  final String? resolvedAt;
  final String? remarks;

  const IssuesEntity({
    this.title,
    this.category,
    this.location,
    this.latitude,
    this.longitude,
    this.description,
    this.issueImages,
    this.status,
    this.priority,
    this.reportedBy,
    this.assignedTo,
    this.resolvedAt,
    this.remarks,
    this.issueId,
  });

  @override
  List<Object?> get props => [
    issueId,
    title,
    category,
    location,
    latitude,
    longitude,
    description,
    issueImages,
    status,
    priority,
    reportedBy,
    assignedTo,
    resolvedAt,
    remarks,
  ];
}
