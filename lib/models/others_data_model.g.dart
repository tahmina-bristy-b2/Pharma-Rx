// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'others_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OthersDataModelAdapter extends TypeAdapter<OthersDataModel> {
  @override
  final int typeId = 4;

  @override
  OthersDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OthersDataModel(
      cid: fields[0] as String,
      userPass: fields[1] as String,
      areaPage: fields[2] as String,
      startTime: fields[3] as String,
      endTime: fields[4] as String,
      version: fields[5] as String,
      deviceId: fields[6] as String,
      deviceModel: fields[7] as String,
      deviceBrand: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OthersDataModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.cid)
      ..writeByte(1)
      ..write(obj.userPass)
      ..writeByte(2)
      ..write(obj.areaPage)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.version)
      ..writeByte(6)
      ..write(obj.deviceId)
      ..writeByte(7)
      ..write(obj.deviceModel)
      ..writeByte(8)
      ..write(obj.deviceBrand);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OthersDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
