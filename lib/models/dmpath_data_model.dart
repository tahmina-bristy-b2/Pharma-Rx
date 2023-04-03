import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
part 'dmpath_data_model.g.dart';

DmPathDataModel dmPathDataModelFromJson(String str) =>
    DmPathDataModel.fromJson(json.decode(str));

String dmPathDataModelToJson(DmPathDataModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 2)
class DmPathDataModel extends HiveObject {
  @HiveField(0)
  String loginUrl;
  @HiveField(1)
  String areaUrl;
  @HiveField(2)
  String doctorUrl;
  @HiveField(3)
  String medicineRxUrl;
  @HiveField(4)
  String submitPhotoUrl;
  @HiveField(5)
  String submitRxUrl;
  @HiveField(6)
  String changePassUrl;
  @HiveField(7)
  String reportRxUrl;
  @HiveField(8)
  String pluginUrl;
  @HiveField(9)
  String timerTrackUrl;
  @HiveField(10)
  String syncNoticeUrl;
  @HiveField(11)
  String submitAttenUrl;

  DmPathDataModel({
    required this.loginUrl,
    required this.areaUrl,
    required this.doctorUrl,
    required this.medicineRxUrl,
    required this.submitPhotoUrl,
    required this.submitRxUrl,
    required this.changePassUrl,
    required this.reportRxUrl,
    required this.pluginUrl,
    required this.timerTrackUrl,
    required this.syncNoticeUrl,
    required this.submitAttenUrl,
  });

  factory DmPathDataModel.fromJson(Map<String, dynamic> json) =>
      DmPathDataModel(
        loginUrl: json["login_url"],
        areaUrl: json["area_url"],
        doctorUrl: json["doctor_url"],
        medicineRxUrl: json["medicine_rx_url"],
        submitPhotoUrl: json["submit_photo_url"],
        submitRxUrl: json["submit_rx_url"],
        changePassUrl: json["change_pass_url"],
        reportRxUrl: json["report_rx_url"],
        pluginUrl: json["plugin_url"],
        timerTrackUrl: json["timer_track_url"],
        syncNoticeUrl: json["sync_notice_url"],
        submitAttenUrl: json["submit_atten_url"],
      );

  Map<String, dynamic> toJson() => {
        "login_url": loginUrl,
        "area_url": areaUrl,
        "doctor_url": doctorUrl,
        "medicine_rx_url": medicineRxUrl,
        "submit_photo_url": submitPhotoUrl,
        "submit_rx_url": submitRxUrl,
        "change_pass_url": changePassUrl,
        "report_rx_url": reportRxUrl,
        "plugin_url": pluginUrl,
        "timer_track_url": timerTrackUrl,
        "sync_notice_url": syncNoticeUrl,
        "submit_atten_url": submitAttenUrl,
      };
}
