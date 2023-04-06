import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
part 'others_data_model.g.dart';

OthersDataModel othersDataModelFromJson(String str) =>
    OthersDataModel.fromJson(json.decode(str));

String othersDataModelToJson(OthersDataModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 4)
class OthersDataModel extends HiveObject {
  @HiveField(0)
  String cid;
  @HiveField(1)
  String userPass;
  @HiveField(2)
  String areaPage;
  @HiveField(3)
  String startTime;
  @HiveField(4)
  String endTime;
  @HiveField(5)
  String version;
  @HiveField(6)
  String deviceId;
  @HiveField(7)
  String deviceModel;
  @HiveField(8)
  String deviceBrand;
  OthersDataModel({
    required this.cid,
    required this.userPass,
    required this.areaPage,
    required this.startTime,
    required this.endTime,
    required this.version,
    required this.deviceId,
    required this.deviceModel,
    required this.deviceBrand,
  });

  factory OthersDataModel.fromJson(Map<String, dynamic> json) =>
      OthersDataModel(
        cid: json["cid"] ?? "",
        userPass: json["user_pass"] ?? "",
        areaPage: json["areaPage"] ?? "",
        startTime: json["start_time"] ?? "",
        endTime: json["end_time"] ?? "",
        version: json["version"] ?? "",
        deviceId: json["device_id"] ?? "",
        deviceModel: json["device_model"] ?? "",
        deviceBrand: json["device_brand"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "user_pass": userPass,
        "areaPage": areaPage,
        "start_time": startTime,
        "end_time": endTime,
        "version": version,
        "device_id": deviceId,
        "device_model": deviceModel,
        "device_brand": deviceBrand,
      };
}
