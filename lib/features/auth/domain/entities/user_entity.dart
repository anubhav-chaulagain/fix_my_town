import 'package:equatable/equatable.dart';

enum UserRole { citizen, authority }

class UserEntity extends Equatable {
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

  const UserEntity({
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

  @override
  List<Object?> get props => [
    fullName,
    email,
    role,
    profilePicture,
    totalReports,
    pendingReports,
    resolvedReports,
    inprogressReports,
    department,
    employeeId,
    assinedIssuesCount,
    completedIssuesCount,
    phoneNumber,
    isActive,
  ];
}
