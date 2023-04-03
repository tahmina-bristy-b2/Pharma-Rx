// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataSyncAndSaveToHive {
  Box? box;
  List medicineList = [];
  List dcrDataList = [];
  var cid = " ";
  var userId = " ";
  var userPassward = " ";

  Future openDcrBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('dcrListData');
  }

  sharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cid = await prefs.getString("CID") ?? " ";
    userId = await prefs.getString("USER_ID") ?? "";
    userPassward = await prefs.getString("PASSWORD") ?? "";
  }

  // Future<dynamic> getDcrData(String sync_url, String cid, String userId,
  //     String userPassward, String areaId, BuildContext context) async {
  //   await openDcrBox();
  //   try {
  //     var response = await http.get(Uri.parse(
  //         '$sync_url/api_doctor/get_doctor?cid=$cid&user_id=$userId&user_pass=$userPassward&area_id=$areaId'));

  //     Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
  //     Map<String, dynamic> res_data = jsonResponseDcrData['res_data'];

  //     var status = res_data['status'];
  //     var doctorList = res_data['doctorList'];

  //     if (status == 'Success') {
  //       await putDcrData(doctorList);
  //       await saveAreaId(areaId);
  //       Timer(
  //           const Duration(seconds: 0),
  //           () => Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => RxScreen(
  //                     address: '',
  //                     areaId: '',
  //                     areaName: '',
  //                     ck: '',
  //                     dcrKey: 0,
  //                     docId: '',
  //                     docName: '',
  //                     uniqueId: 0,
  //                     draftRxMedicinItem: [],
  //                     image1: '',
  //                   ),
  //                 ),
  //               ));
  //       // Timer(const Duration(seconds: 3), () => Navigator.pop(context));
  //       // String msg = 'DCR data synchronizing... ';

  //       // ScaffoldMessenger.of(context)
  //       //     .showSnackBar(const SnackBar(content: Text('Sync success')));
  //       // return buildShowDialog(context, msg);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Did not sync Doctor list')));
  //     }
  //   } on Exception catch (_) {
  //     // print(e);
  //     throw Exception("Error on server");
  //   }
  //   // return Future.value(true);
  // }

  Future putDcrData(dcrData) async {
    await box!.clear();

    for (var d in dcrData) {
      box!.add(d);
    }
  }

  Future medicinOpenBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('MedicineList');
  }

  Future<dynamic> getMedicineData(
      String medicine_rx_url, String cid, BuildContext context) async {
    await sharedpref();
    print(
        "medicine_rx_url  '$medicine_rx_url?cid=$cid&user_id=$userId&user_pass=$userPassward'");
    print("cid $cid");
    print("userDI $userId");
    print("userPassward $userPassward");
    await medicinOpenBox();
    try {
      // ignore: prefer_interpolation_to_compose_strings
      var response = await http.get(Uri.parse(
          '$medicine_rx_url?cid=$cid&user_id=$userId&user_pass=$userPassward'));

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      // print(jsonResponse);
      Map<String, dynamic> medicineData = jsonResponse['res_data'];
      print(medicineData);
      var rxItemList = medicineData['rxItemList'];

      var status = medicineData['status'];

      if (status == 'Success') {
        await putMedicinData(rxItemList);

        // String msg = 'Medicine Synchronizing....';

        // // ScaffoldMessenger.of(context)
        // //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        // return buildShowDialog(context, msg);
        return medicineData;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Did not sync Medicine list')));
      }
    } on Exception catch (e) {
      print(e);
      // throw Exception("Error on server");
    }
    // return Future.value(true);
  }

  Future putMedicinData(medicinData) async {
    await box!.clear();
    // print("medicine data ${medicinData}");
    for (var m in medicinData) {
      box!.add(m);
    }
  }

  Future saveAreaId(String areaId) async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('AreaId');
    box!.put('areaId', areaId);
  }

  buildShowDialog(BuildContext context, String msg) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 10,
              ),
              DefaultTextStyle(
                style: const TextStyle(color: Colors.white, fontSize: 18),
                child: Text(msg),
              )
            ],
          );
        });
  }
}
