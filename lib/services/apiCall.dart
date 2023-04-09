import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharma_rx/models/boxes.dart';
import 'package:pharma_rx/models/dmpath_data_model.dart';
import 'package:pharma_rx/services/sharedPrefernce.dart';
import 'package:shared_preferences/shared_preferences.dart';

var cid;
var user_id;
var user_pass;
var deviceId;
var deviceBrand;
var deviceModel;
var appVersion;
var area_url;
var report_rx_url;
var doctor_url;
String timer_track_url = "";
String sync_notice_url = "";

sharedpref() async {
  DmPathDataModel? dmPathData;
  dmPathData = Boxes.getDmPathDataModel().get('dmPathData');

  SharedPreferences prefs = await SharedPreferences.getInstance();

  cid = await prefs.getString("CID");
  user_id = await prefs.getString("USER_ID");
  user_pass = await prefs.getString("PASSWORD");
  deviceId = await prefs.getString("deviceId");
  deviceBrand = await prefs.getString("deviceBrand");
  deviceModel = await prefs.getString("deviceModel");
  appVersion = await prefs.getString("version");
  area_url = await prefs.getString("area_url");
  sync_notice_url = prefs.getString("sync_notice_url") ?? "";
  report_rx_url = await prefs.getString("report_rx_url");
  doctor_url = await prefs.getString("doctor_url");
  //timer_track_url = prefs.getString("timer_track_url") ?? "";
  timer_track_url = dmPathData!.timerTrackUrl;

  // print(prefs.getKeys());
}

class ApiCall {
  Future loginSecond() async {
    sharedpref();

    final response = await http.get(
      Uri.parse(
          'http://a311.yeapps.com/skf_api/api_rx/check_user?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$deviceId&device_brand=$deviceBrand&device_model=$deviceModel&app_v=$appVersion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var data = json.decode(response.body);

    var status = data['status'];
    if (status == "Success") {
      return data;
    }
    return "404";
  }

  // =================================================================================
  // =================================================================================
  // =================================================================================

  Future getRegionList() async {
    await sharedpref();
    // print("cid ashcbe ${cid}");
    // print("userid ashcbe ${userId}");
    // print("userpass ashcbe ${userpass}");
    print(
        '$area_url?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$deviceId');

    final response = await http.get(
      Uri.parse(
          '$area_url?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$deviceId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var data = json.decode(response.body);

    var territoryData = data["res_data"];

    if (territoryData["status"] == "Success") {
      return territoryData;
    } else {
      return "404";
    }
  }

  // =================================================================================
  // =================================================================================
  // =================================================================================

  Future doctorArea(newValueofreg, newValueofarea, newValueofterr) async {
    sharedpref();
    print(doctor_url +
        "?cid=$cid&user_id=$user_id&user_pass=$user_pass&region_id=$newValueofreg&area_id=$newValueofarea&territory_id=$newValueofterr");
    final response = await http.post(
      Uri.parse('$doctor_url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "cid": cid,
        "user_id": user_id,
        "user_pass": user_pass,
        "region_id": newValueofreg,
        "area_id": newValueofarea,
        "territory_id": newValueofterr == null ? "" : newValueofterr,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      var status = data["res_data"]["status"];
      if (status == "Success") {
        List doctorData = data["res_data"]["doctorList"];

        return doctorData;
      }

      return "404";
    }

    // if (response.statusCode == 200) {
    //   final userList = luckyModelFromJson(response.body);
    //   //print(userList.categoryList[0].subCategoryList[0].productList[0].pName);
    //   return userList;
    // } else {
    //   return userList;
    // }
  }

  // =================================================================================
  // =============================""Report Skf""=========================================
  // =================================================================================

  Future getReport(String date) async {
    await sharedpref();
    // print("cid ashcbe ${cid}");
    // print("userid ashcbe ${userId}");
    // print("userpass ashcbe ${userpass}");
    // print("deviceId ashcbe ${deviceId}");

    final response = await http.get(
      Uri.parse(
          '$report_rx_url?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$deviceId&req_date=$date'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var data = json.decode(response.body);

    var status = data["res_data"]['status'];

    if (status == "Success") {
      return data;
    } else {
      return "404";
    }
  }

  Future timeTracker(String location) async {
    await sharedpref();
    // print("ok ok ${timer_track_url}");
    // print(cid);
    // print(user_id);
    // print(user_pass);
    print(
        "ami eikhne          =================================================");
    print(
        'traker==========$timer_track_url?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$deviceId&locations=$location');
    if (location != "") {
      final response = await http.post(
        Uri.parse(
            // 'w05.yeapps.com/acme_api/api_expense_submit/submit_data'
            '$timer_track_url?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$deviceId&locations=$location'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        return data;
      }
    }

    return "Null";
  }
}

///*************************************************** *************************************///
///******************************** Notice [[Homepage]] ******************************************///
///******************************** ********************************************************///

noticeEvent() async {
  await sharedpref();
  print("$sync_notice_url?cid=$cid&user_id=$user_id&user_pass=$user_pass");

  try {
    final http.Response response = await http.get(
        Uri.parse(
            "$sync_notice_url?cid=$cid&user_id=$user_id&user_pass=$user_pass"),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var noticeDetails = json.decode(response.body);
    print(noticeDetails);
    String status = noticeDetails['status'];
    List noticeList = noticeDetails['noticeList'];
    if (status == "Success") {
      return noticeList;
    } else {
      return "error";
    }
  } catch (e) {
    print('notice error message: $e');
  }
  return "error";
}
