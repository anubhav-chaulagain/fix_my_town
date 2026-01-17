import 'package:fix_my_town/core/constants/hive_table_constants.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTypeId)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String fullname;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? password;

  @HiveField(4)
  final String role;

  @HiveField(5)
  final String? profilePicture;

  @HiveField(6)
  final String? status;

  UserHiveModel({
    String? userId,
    required this.fullname,
    required this.email,
    this.password,
    required this.role,
    this.profilePicture,
    this.status,
  }) : userId = userId ?? Uuid().v4();

  // Convert model to auth entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullname,
      email: email,
      password: password,
      role: role,
      profilePicture: profilePicture,
      status: status,
    );
  }

  // Convert auth entity to model
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      fullname: entity.fullName,
      email: entity.email,
      password: entity.password,
      role: entity.role,
      profilePicture: entity.profilePicture,
      status: entity.status,
    );
  }

  // Convert list of models to list of auth entities
  static List<UserEntity> toEntityList(List<UserHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
