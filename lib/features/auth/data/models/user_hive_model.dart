import 'package:fix_my_town/core/constants/hive_table_constants.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:hive/hive.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTypeId)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String? fullname;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? password;

  @HiveField(3)
  final String? role;

  @HiveField(4)
  final String? profilePicture;

  @HiveField(5)
  final String? totalReports;

  @HiveField(6)
  final String? pendingReports;

  @HiveField(7)
  final String? resolvedReports;

  @HiveField(8)
  final String? inprogressReports;

  @HiveField(9)
  final String? department;

  @HiveField(10)
  final String? employeeId;

  @HiveField(11)
  final String? assinedIssuesCount;

  @HiveField(12)
  final String? completedIssuesCount;

  @HiveField(13)
  final String? phoneNumber;

  @HiveField(14)
  final String? isActive;

  UserHiveModel({
    this.fullname,
    required this.email,
    this.password,
    this.role,
    this.profilePicture,
    this.totalReports,
    this.pendingReports,
    this.resolvedReports,
    this.inprogressReports,
    this.department,
    this.employeeId,
    this.assinedIssuesCount,
    this.completedIssuesCount,
    this.phoneNumber,
    this.isActive,
  });

  // Convert model to auth entity
  UserEntity toEntity() {
    return UserEntity(
      fullName: fullname,
      email: email,
      password: password,
      role: role,
      profilePicture: profilePicture,
      totalReports: totalReports,
      pendingReports: pendingReports,
      resolvedReports: resolvedReports,
      inprogressReports: inprogressReports,
      department: department,
      employeeId: employeeId,
      assinedIssuesCount: assinedIssuesCount,
      completedIssuesCount: completedIssuesCount,
      phoneNumber: phoneNumber,
      isActive: isActive,
    );
  }

  // Convert auth entity to model
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      fullname: entity.fullName,
      email: entity.email,
      password: entity.password,
      role: entity.role,
      profilePicture: entity.profilePicture,
      totalReports: entity.totalReports,
      pendingReports: entity.pendingReports,
      resolvedReports: entity.resolvedReports,
      inprogressReports: entity.inprogressReports,
      department: entity.department,
      employeeId: entity.employeeId,
      assinedIssuesCount: entity.assinedIssuesCount,
      completedIssuesCount: entity.completedIssuesCount,
      phoneNumber: entity.phoneNumber,
      isActive: entity.isActive,
    );
  }

  // Convert list of models to list of auth entities
  static List<UserEntity> toEntityList(List<UserHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
