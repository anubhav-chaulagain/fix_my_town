import 'package:fix_my_town/core/constants/hive_table_constants.dart';
import 'package:fix_my_town/features/issues/domain/entities/issues_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'issues_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.reportTypeId)
class IssuesHiveModel extends HiveObject {
  @HiveField(0)
  final String? issueId;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? category;

  @HiveField(3)
  final String? location;

  @HiveField(4)
  final String? latitude;

  @HiveField(5)
  final String? longitude;

  @HiveField(6)
  final String? description;

  @HiveField(7)
  final String? issueImages;

  @HiveField(8)
  final String? status;

  @HiveField(9)
  final String? priority;

  @HiveField(10)
  final String? reportedBy;

  @HiveField(11)
  final String? assignedTo;

  @HiveField(12)
  final String? resolvedAt;

  @HiveField(13)
  final String? remarks;

  IssuesHiveModel({
    String? issueId,
    this.title,
    this.category,
    this.location,
    this.latitude,
    this.longitude,
    this.description,
    this.issueImages,
    String? status,
    String? priority,
    this.reportedBy,
    this.assignedTo,
    this.resolvedAt,
    this.remarks,
  }) : issueId = issueId ?? const Uuid().v4(),
       status = status ?? 'open',
       priority = priority ?? 'low';

  IssuesEntity toEntity() {
    return IssuesEntity(
      title: title,
      category: category,
      location: location,
      latitude: latitude,
      longitude: longitude,
      description: description,
      issueImages: issueImages,
      status: status,
      priority: priority,
      reportedBy: reportedBy,
      assignedTo: assignedTo,
      resolvedAt: resolvedAt,
      remarks: remarks,
    );
  }

  factory IssuesHiveModel.fromEntity(IssuesEntity entity) {
    return IssuesHiveModel(
      title: entity.title,
      category: entity.category,
      location: entity.location,
      latitude: entity.latitude,
      longitude: entity.longitude,
      description: entity.description,
      issueImages: entity.issueImages,
      status: entity.status,
      priority: entity.priority,
      reportedBy: entity.reportedBy,
      assignedTo: entity.assignedTo,
      resolvedAt: entity.resolvedAt,
      remarks: entity.remarks,
    );
  }

  static List<IssuesEntity> toEntityList(List<IssuesHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
