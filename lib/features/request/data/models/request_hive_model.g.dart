// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RequestHiveModelAdapter extends TypeAdapter<RequestHiveModel> {
  @override
  final int typeId = 3;

  @override
  RequestHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RequestHiveModel(
      requestId: fields[0] as String?,
      recipientBloodId: fields[1] as String,
      hospitalId: fields[2] as String,
      postedBy: fields[3] as String?,
      donorId: fields[4] as String?,
      recipientDetails: fields[5] as String,
      recipientCondition: fields[6] as String,
      requestFor: fields[7] as String,
      relationToPatient: fields[8] as String?,
      patientName: fields[9] as String?,
      patientPhone: fields[10] as String?,
      requestStatus: fields[11] as String?,
      createdAt: fields[12] as DateTime?,
      updatedAt: fields[13] as DateTime?,
      cacheType: fields[14] as String? ?? RequestHiveModel.cacheTypePending,
    );
  }

  @override
  void write(BinaryWriter writer, RequestHiveModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.requestId)
      ..writeByte(1)
      ..write(obj.recipientBloodId)
      ..writeByte(2)
      ..write(obj.hospitalId)
      ..writeByte(3)
      ..write(obj.postedBy)
      ..writeByte(4)
      ..write(obj.donorId)
      ..writeByte(5)
      ..write(obj.recipientDetails)
      ..writeByte(6)
      ..write(obj.recipientCondition)
      ..writeByte(7)
      ..write(obj.requestFor)
      ..writeByte(8)
      ..write(obj.relationToPatient)
      ..writeByte(9)
      ..write(obj.patientName)
      ..writeByte(10)
      ..write(obj.patientPhone)
      ..writeByte(11)
      ..write(obj.requestStatus)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.cacheType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
