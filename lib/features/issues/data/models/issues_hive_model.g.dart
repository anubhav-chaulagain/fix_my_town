// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issues_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IssuesHiveModelAdapter extends TypeAdapter<IssuesHiveModel> {
  @override
  final int typeId = 1;

  @override
  IssuesHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IssuesHiveModel(
      issueId: fields[0] as String?,
      title: fields[1] as String?,
      category: fields[2] as String?,
      location: fields[3] as String?,
      latitude: fields[4] as String?,
      longitude: fields[5] as String?,
      description: fields[6] as String?,
      issueImages: fields[7] as String?,
      status: fields[8] as String?,
      priority: fields[9] as String?,
      reportedBy: fields[10] as String?,
      assignedTo: fields[11] as String?,
      resolvedAt: fields[12] as String?,
      remarks: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IssuesHiveModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.issueId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.issueImages)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.priority)
      ..writeByte(10)
      ..write(obj.reportedBy)
      ..writeByte(11)
      ..write(obj.assignedTo)
      ..writeByte(12)
      ..write(obj.resolvedAt)
      ..writeByte(13)
      ..write(obj.remarks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssuesHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
