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
  OthersDataModel({
    required this.cid,
    required this.userPass,
    required this.areaPage,
    required this.startTime,
    required this.endTime,
  });

  factory OthersDataModel.fromJson(Map<String, dynamic> json) =>
      OthersDataModel(
        cid: json["cid"] ?? "",
        userPass: json["user_pass"] ?? "",
        areaPage: json["areaPage"] ?? "",
        startTime: json["start_time"] ?? "",
        endTime: json["end_time"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "user_pass": userPass,
        "areaPage": areaPage,
        "start_time": startTime,
        "end_time": endTime,
      };
}
