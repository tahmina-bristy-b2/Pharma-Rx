// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dmpath_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DmPathDataModelAdapter extends TypeAdapter<DmPathDataModel> {
  @override
  final int typeId = 2;

  @override
  DmPathDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DmPathDataModel(
      loginUrl: fields[0] as String,
      areaUrl: fields[1] as String,
      doctorUrl: fields[2] as String,
      medicineRxUrl: fields[3] as String,
      submitPhotoUrl: fields[4] as String,
      submitRxUrl: fields[5] as String,
      changePassUrl: fields[6] as String,
      reportRxUrl: fields[7] as String,
      pluginUrl: fields[8] as String,
      timerTrackUrl: fields[9] as String,
      syncNoticeUrl: fields[10] as String,
      submitAttenUrl: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DmPathDataModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.loginUrl)
      ..writeByte(1)
      ..write(obj.areaUrl)
      ..writeByte(2)
      ..write(obj.doctorUrl)
      ..writeByte(3)
      ..write(obj.medicineRxUrl)
      ..writeByte(4)
      ..write(obj.submitPhotoUrl)
      ..writeByte(5)
      ..write(obj.submitRxUrl)
      ..writeByte(6)
      ..write(obj.changePassUrl)
      ..writeByte(7)
      ..write(obj.reportRxUrl)
      ..writeByte(8)
      ..write(obj.pluginUrl)
      ..writeByte(9)
      ..write(obj.timerTrackUrl)
      ..writeByte(10)
      ..write(obj.syncNoticeUrl)
      ..writeByte(11)
      ..write(obj.submitAttenUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmPathDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
