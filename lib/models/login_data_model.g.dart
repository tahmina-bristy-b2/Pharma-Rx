// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginDataModelAdapter extends TypeAdapter<LoginDataModel> {
  @override
  final int typeId = 3;

  @override
  LoginDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginDataModel(
      status: fields[0] as String,
      userId: fields[1] as String,
      mobileNo: fields[2] as String,
      timerFlag: fields[3] as bool,
      rxGalleryAllow: fields[4] as bool,
      rxDocMust: fields[5] as bool,
      noticeFlag: fields[6] as bool,
      userName: fields[7] as String,
      rxTypeList: (fields[8] as List).cast<String>(),
      rxTypeMust: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LoginDataModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.mobileNo)
      ..writeByte(3)
      ..write(obj.timerFlag)
      ..writeByte(4)
      ..write(obj.rxGalleryAllow)
      ..writeByte(5)
      ..write(obj.rxDocMust)
      ..writeByte(6)
      ..write(obj.noticeFlag)
      ..writeByte(7)
      ..write(obj.userName)
      ..writeByte(8)
      ..write(obj.rxTypeList)
      ..writeByte(9)
      ..write(obj.rxTypeMust);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
