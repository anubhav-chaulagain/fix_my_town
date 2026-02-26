import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';

class UserApiModel {
  final String? fullName;
  final String email;
  final String? password;
  final String? role;
  final String? profilePicture;

  // Citizen stats
  final String? totalReports;
  final String? pendingReports;
  final String? resolvedReports;
  final String? inprogressReports;

  // Authority stats
  final String? department;
  final String? employeeId;
  final String? assinedIssuesCount;
  final String? completedIssuesCount;
  final String? phoneNumber;
  final String? isActive;

  UserApiModel({
    this.fullName,
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

  // to JSON
  Map<String, dynamic> toJson() {
    return {
      "fullname": fullName,
      "email": email,
      "password": password,
      "role": role,
      "profilePicture": profilePicture,
      "totalReports": totalReports,
      "pendingReports": pendingReports,
      "resolvedReports": resolvedReports,
      "inprogressReports": inprogressReports,
      "department": department,
      "employeeId": employeeId,
      "assinedIssuesCount": assinedIssuesCount,
      "completedIssuesCount": completedIssuesCount,
      "phoneNumber": phoneNumber,
      "isActive": isActive,
    };
  }

  // Special toJson for update (only include non-null fields)
  Map<String, dynamic> toJsonForUpdate() {
    final Map<String, dynamic> data = {"fullname": fullName, "email": email};

    if (password != null && password!.isNotEmpty) {
      data["password"] = password;
    }
    if (profilePicture != null && profilePicture!.isNotEmpty) {
      data["profilePicture"] = profilePicture;
    }

    return data;
  }

  // from JSON
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      fullName: json["fullname"],
      email: json["email"],
      password: json["password"],
      role: json["role"],
      profilePicture: json["profilePicture"],
      totalReports: json["totalReports"]?.toString(),
      pendingReports: json["pendingReports"]?.toString(),
      resolvedReports: json["resolvedReports"]?.toString(),
      inprogressReports: json["inprogressReports"]?.toString(),
      department: json["department"],
      employeeId: json["employeeId"],
      assinedIssuesCount: json["assignedIssuesCount"]
          ?.toString(), // note: API uses "assignedIssuesCount"
      completedIssuesCount: json["completedIssuesCount"]?.toString(),
      phoneNumber: json["phoneNumber"],
      isActive: json["isActive"]?.toString(),
    );
  }

  // to Entity
  UserEntity toEntity() {
    return UserEntity(
      fullName: fullName,
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

  // from Entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      fullName: entity.fullName,
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
}
