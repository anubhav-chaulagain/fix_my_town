// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserHiveModelAdapter extends TypeAdapter<UserHiveModel> {
  @override
  final int typeId = 0;

  @override
  UserHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserHiveModel(
      fullname: fields[0] as String?,
      email: fields[1] as String,
      password: fields[2] as String?,
      role: fields[3] as String?,
      profilePicture: fields[4] as String?,
      totalReports: fields[5] as String?,
      pendingReports: fields[6] as String?,
      resolvedReports: fields[7] as String?,
      inprogressReports: fields[8] as String?,
      department: fields[9] as String?,
      employeeId: fields[10] as String?,
      assinedIssuesCount: fields[11] as String?,
      completedIssuesCount: fields[12] as String?,
      phoneNumber: fields[13] as String?,
      isActive: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserHiveModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.fullname)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.profilePicture)
      ..writeByte(5)
      ..write(obj.totalReports)
      ..writeByte(6)
      ..write(obj.pendingReports)
      ..writeByte(7)
      ..write(obj.resolvedReports)
      ..writeByte(8)
      ..write(obj.inprogressReports)
      ..writeByte(9)
      ..write(obj.department)
      ..writeByte(10)
      ..write(obj.employeeId)
      ..writeByte(11)
      ..write(obj.assinedIssuesCount)
      ..writeByte(12)
      ..write(obj.completedIssuesCount)
      ..writeByte(13)
      ..write(obj.phoneNumber)
      ..writeByte(14)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
