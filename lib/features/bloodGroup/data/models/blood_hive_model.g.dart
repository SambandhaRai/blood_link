// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BloodHiveModelAdapter extends TypeAdapter<BloodHiveModel> {
  @override
  final int typeId = 1;

  @override
  BloodHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BloodHiveModel(
      bloodId: fields[0] as String?,
      bloodGroup: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BloodHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.bloodId)
      ..writeByte(1)
      ..write(obj.bloodGroup);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BloodHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
