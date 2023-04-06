import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
part 'login_data_model.g.dart';

LoginDataModel loginDataModelFromJson(String str) =>
    LoginDataModel.fromJson(json.decode(str));

String loginDataModelToJson(LoginDataModel data) => json.encode(data.toJson());

@HiveType(typeId: 3)
class LoginDataModel extends HiveObject {
  @HiveField(0)
  String status;
  @HiveField(1)
  String userId;
  @HiveField(2)
  String mobileNo;
  @HiveField(3)
  bool timerFlag;
  @HiveField(4)
  bool rxGalleryAllow;
  @HiveField(5)
  bool rxDocMust;
  @HiveField(6)
  bool noticeFlag;
  @HiveField(7)
  String userName;
  @HiveField(8)
  List<String> rxTypeList;
  @HiveField(9)
  bool rxTypeMust;
  LoginDataModel({
    required this.status,
    required this.userId,
    required this.mobileNo,
    required this.timerFlag,
    required this.rxGalleryAllow,
    required this.rxDocMust,
    required this.noticeFlag,
    required this.userName,
    required this.rxTypeList,
    required this.rxTypeMust,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) => LoginDataModel(
        status: json["status"],
        userId: json["user_id"],
        mobileNo: json["mobile_no"],
        timerFlag: json["timer_flag"],
        rxGalleryAllow: json["rx_gallery_allow"],
        rxDocMust: json["rx_doc_must"],
        noticeFlag: json["notice_flag"],
        userName: json["user_name"],
        rxTypeList: List<String>.from(json["rx_type_list"].map((x) => x)),
        rxTypeMust: json["rx_type_must"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "user_id": userId,
        "mobile_no": mobileNo,
        "timer_flag": timerFlag,
        "rx_gallery_allow": rxGalleryAllow,
        "rx_doc_must": rxDocMust,
        "notice_flag": noticeFlag,
        "user_name": userName,
        "rx_type_list": List<dynamic>.from(rxTypeList.map((x) => x)),
        "rx_type_must": rxTypeMust,
      };
}
