import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';

class UserApiModel {
  final String? userId;
  final String fullName;
  final String email;
  final String? password;
  final String? role;
  final String? profilePicture;
  final String? status;

  UserApiModel({
    this.userId,
    required this.fullName,
    required this.email,
    this.password,
    this.role,
    this.profilePicture,
    this.status,
  });

  // to JSON
  Map<String, dynamic> toJson() {
    return {
      "fullname": fullName,
      "email": email,
      "role": role,
      "profilePicture": profilePicture,
      "status": status,
      "password": password,
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
      userId: json["_id"],
      fullName: json["fullname"],
      email: json["email"],
      role: json["role"] ?? 'citizen',
      profilePicture: json["profilePicture"],
      status: json["status"],
    );
  }

  // to Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      password: password,
      role: role,
      profilePicture: profilePicture,
      status: status,
    );
  }

  // from Entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      role: entity.role,
      profilePicture: entity.profilePicture,
      status: entity.status,
    );
  }
}
