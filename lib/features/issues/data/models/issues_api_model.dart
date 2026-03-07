// issues_api_model.dart
import 'package:fix_my_town/features/issues/domain/entities/issues_entity.dart';

class IssuesApiModel {
  final String? id;
  final String? title;
  final String? category;
  final String? location;
  final String? latitude;
  final String? longitude;
  final String? description;
  final List<String>? issueImages;
  final String? status;
  final String? priority;
  final String? reportedBy;
  final String? assignedTo;
  final String? resolvedAt;
  final String? remarks;
  final String? createdAt;

  IssuesApiModel({
    this.id,
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
    this.createdAt,
  });

  factory IssuesApiModel.fromJson(Map<String, dynamic> json) {
    return IssuesApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      category: json['category'] is Map
          ? json['category']['_id'] as String?
          : json['category'] as String?,
      location: json['location'] as String?,
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      description: json['description'] as String?,
      issueImages: json['issueImages'] != null
          ? List<String>.from(json['issueImages'])
          : null,
      status: json['status'] as String?,
      priority: json['priority'] as String?,
      reportedBy: json['reportedBy'] is Map
          ? json['reportedBy']['_id'] as String?
          : json['reportedBy'] as String?,
      assignedTo: json['assignedTo'] is Map
          ? json['assignedTo']['_id'] as String?
          : json['assignedTo'] as String?,
      resolvedAt: json['resolvedAt'] as String?,
      remarks: json['remarks'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (location != null) 'location': location,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (remarks != null) 'remarks': remarks,
    };
  }

  IssuesEntity toEntity() {
    return IssuesEntity(
      issueId: id,
      title: title,
      category: category,
      location: location,
      latitude: latitude,
      longitude: longitude,
      description: description,
      issueImages: issueImages?.join(','),
      status: status,
      priority: priority,
      reportedBy: reportedBy,
      assignedTo: assignedTo,
      resolvedAt: resolvedAt,
      remarks: remarks,
    );
  }

  factory IssuesApiModel.fromEntity(IssuesEntity entity) {
    return IssuesApiModel(
      id: entity.issueId,
      title: entity.title,
      category: entity.category,
      location: entity.location,
      latitude: entity.latitude,
      longitude: entity.longitude,
      description: entity.description,
      issueImages: entity.issueImages?.split(','),
      status: entity.status,
      priority: entity.priority,
      reportedBy: entity.reportedBy,
      assignedTo: entity.assignedTo,
      resolvedAt: entity.resolvedAt,
      remarks: entity.remarks,
    );
  }

  static List<IssuesEntity> toEntityList(List<IssuesApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
