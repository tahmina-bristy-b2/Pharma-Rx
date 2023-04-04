import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:pharma_rx/services/all_services.dart';
import 'package:pharma_rx/services/apis.dart';
import 'package:pharma_rx/services/data_provider.dart';
import 'package:pharma_rx/services/sharedPrefernce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Repository {
  Future<String> getDmPathData(
      String? deviceId,
      String? deviceBrand,
      String? deviceModel,
      String cid,
      String userId,
      String password,
      BuildContext context) async {
    String loginUrl = '';
    try {
      http.Response response = await Dataproviders().dmpathResponse(cid);
      var userInfo = json.decode(response.body);
      //print("userinfo ashbe from loginpage ${userInfo}");
      var status = userInfo['res_data'];
      print("userInfo======================$userInfo");
      print("status======================$status");

      if (status['res_data'] == 'Welcome to mReporting.') {
        RxAllServices().toastMessage('Wrong CID', Colors.red, Colors.white, 16);
      } else {
        print("object==");
        loginUrl = status['login_url'];
        String areaUrl = status['area_url'] ?? "";
        String submitAttenUrl = status['submit_atten_url'] ?? "";
        String doctorUrl = status['doctor_url'] ?? "";
        String submitRxUrl = status['submit_rx_url'] ?? "";
        String reportRxUrl = status['report_rx_url'] ?? " ";
        String submitPhotoUrl = status['submit_photo_url'] ?? "";
        String medicineRxUrl = status['medicine_rx_url'] ?? "";
        String changePassUrl = status['change_pass_url'] ?? "";
        String timerTrackUrl = status['timer_track_url'] ?? "";
        String pluginUrl = status['plugin_url'] ?? "";
        String syncNoticeUrl = status['sync_notice_url'] ?? "";

        print(
            "object=======================doctorUrl=$doctorUrl,loginUrl=$loginUrl,submitAttenUrl =$submitAttenUrl,doctorUrl =$doctorUrl,submitRxUrl=$submitRxUrl,");
        // String photo_url = status['photo_url'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('submit_atten_url', submitAttenUrl);
        await prefs.setString('medicine_rx_url', medicineRxUrl);
        await prefs.setString('area_url', areaUrl);
        await prefs.setString('doctor_url', doctorUrl);
        await prefs.setString('submit_rx_url', submitRxUrl);
        await prefs.setString('report_rx_url', reportRxUrl);
        await prefs.setString('submit_photo_url', submitPhotoUrl);
        await prefs.setString('change_pass_url', changePassUrl);
        await prefs.setString('timer_track_url', timerTrackUrl);
        await prefs.setString('plugin_url', pluginUrl);
        await prefs.setString('sync_notice_url', syncNoticeUrl);

        // await prefs.setString('photo_url', photo_url);

        // login(deviceId, deviceBrand, deviceModel, cid, userId, password,
        //     login_url, context);
        return loginUrl;
      }
      return loginUrl;
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> getloginInfo(
      String? deviceId,
      String? deviceBrand,
      String? deviceModel,
      String cid,
      String userId,
      String password,
      String loginUrl,
      String version,
      List<String> rxTypeList) async {
    Map<String, dynamic> userInfo = {};
    try {
      print(Apis().login(deviceId, deviceBrand, deviceModel, cid, userId,
          password, loginUrl, version));
      final http.Response response = await Dataproviders().loginResponse(
          deviceId,
          deviceBrand,
          deviceModel,
          cid,
          userId,
          password,
          loginUrl,
          version);
      userInfo = json.decode(response.body);

      print(userInfo);
      String status = userInfo['status'];

      if (status == 'Success') {
        bool timerFlag = false;
        String userName = userInfo['user_name'];
        String userId = userInfo['user_id'];

        String mobileNo = userInfo['mobile_no'];
        bool rxDocMustFlag = userInfo["rx_doc_must"];
        bool rxTypeMustFlag = userInfo["rx_type_must"];
        bool noticeFlag = userInfo["notice_flag"];

        bool rxGalAllowFlag = userInfo["rx_gallery_allow"];
        timerFlag = userInfo["timer_flag"];

        print("Notice Flage          :$noticeFlag");
        print(timerFlag);

        List rxTypeListData = userInfo["rx_type_list"];
        rxTypeList.clear();
        rxTypeListData.forEach((element) {
          rxTypeList.add(element);
        });
        print(rxTypeList);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('areaPage', userInfo['area_page'].toString());
        await prefs.setString('userName', userName);
        await prefs.setString('user_id', userId);
        await prefs.setString('deviceId', deviceId!);
        await prefs.setString('deviceBrand', deviceBrand!);
        await prefs.setString('deviceModel', deviceModel!);
        await prefs.setString('version', version);
        await prefs.setString('mobile_no', mobileNo);
        await prefs.setBool('rxDocMustFlag', rxDocMustFlag);
        await prefs.setBool('rxTypeMustFlag', rxTypeMustFlag);
        await prefs.setBool('rxGalAllowFlag', rxGalAllowFlag);
        await prefs.setBool('timer_flag', timerFlag);
        await prefs.setBool('notice_flag', noticeFlag);
        await prefs.setStringList('rxTypeList', rxTypeList);
        await prefs.setString('PASSWORD', password);

        SharedPreferncesMethod().sharedPreferenceSetDataForLogin(cid, userId);

        // Hive.openBox('MedicineList').then(
        //   (value) {
        //     // var mymap = value.toMap().values.toList();
        //     List dcrDataList = value.toMap().values.toList();
        //     print(dcrDataList.length);
        //   },
        // );
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MyHomePage(
        //       userName: userName,
        //       user_id: user_id,
        //     ),
        //   ),
        // );\

        return userInfo;
      } else {
        RxAllServices().toastMessage(
            'Wrong user Id and Password', Colors.red, Colors.white, 16);
        // setState(() {
        //   isLoading = false;
        // });
        //_submitToastforOrder2();
        return userInfo;
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
  }
}
