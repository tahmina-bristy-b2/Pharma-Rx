import 'dart:async';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:location/location.dart';
import 'package:pharma_rx/main.dart';
import 'package:pharma_rx/models/boxes.dart';
import 'package:pharma_rx/models/login_data_model.dart';
import 'package:pharma_rx/models/others_data_model.dart';
import 'package:pharma_rx/services/apiCall.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoding/geocoding.dart' as geocoding;

double lat = 0.0;
double long = 0.0;
String location = "";
String address = "";

class RxAllServices {
  void toastMessage(
      String msg, Color backgroundColor, Color textColor, fontSize) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16);
  }

  getPermission(Location location, LoginDataModel? loginDataInfo) async {
    print(
        "################################ b################################################");
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    if (_serviceEnabled &&
        _permissionGranted == PermissionStatus.granted &&
        loginDataInfo!.timerFlag == true) {
      //await initializeService();

      BGservice.serviceOn();
      print('Starting Background Service...');

      print('Starting Background Service...');
    }

    //setState(() {});
  }

  // Future<Map<String, dynamic>> getDeviceInfo(
  //     Box<OthersDataModel>? otherDataBox, String version) async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   Map<String, dynamic> dataMap = {};

  //   var androidDeviceInfo = await deviceInfo.androidInfo;
  //   // deviceId = androidDeviceInfo.id!;
  //   dataMap["deviceBrand"] = deviceBrand = androidDeviceInfo.brand!;
  //   deviceModel = androidDeviceInfo.model!;

  //   try {
  //     deviceId = (await PlatformDeviceId.getDeviceId)!;
  //     // print(deviceId);
  //   } on PlatformException {

  //     deviceId = 'Failed to get deviceId.';
  //   }
  //   dataMap = {
  //     "deviceId": deviceId,
  //     "deviceBrand": deviceBrand,
  //     "deviceModel": deviceModel
  //   };
  //   otherDataBox = Boxes.getOthersDataModel();
  //   otherDataBox.toMap().forEach((key, value) {
  //     value.deviceId = deviceId;
  //     value.deviceBrand = deviceBrand;
  //     value.deviceModel = deviceModel;
  //     value.version = version;
  //   });

  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('deviceId', deviceId);
  //   await prefs.setString('deviceBrand', deviceBrand);
  //   await prefs.setString('deviceModel', deviceModel);
  //   return dataMap;
  // }
}

class BGservice {
  static Future<void> serviceOn() async {
    await initializeService();
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
      initialNotificationTitle: "Pharma-Rx",
      initialNotificationContent: "Background Service is Running",
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

FutureOr<bool> onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
  return true;
}

void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  //********************Loop start********************
  Timer.periodic(const Duration(minutes: 5), (timer) async {
    // if (!(await service.isServiceRunning())) timer.cancel();

    // //     //------------Internet Connectivity Check---------------------------
    // final bool isConnected = await InternetConnectionChecker().hasConnection;
    // print('Internet connection: $isConnected');
    // // // ----------------------------------------------------------------------
    // //     //----------------Set Notification------------------
    // if (isConnected) {
    //   service.setNotificationInfo(
    //     title: "mRep7",
    //     content: "Updated at ${DateTime.now()}",
    //   );
    // } else {
    //   service.setNotificationInfo(
    //     title: "mRep7",
    //     content: "Updated at ${DateTime.now()}",
    //   );
    // }

    //     //------------------------Geo Location-----------------

    try {
      geo.Position? position = await geo.Geolocator.getCurrentPosition();
      if (position != null) {
        lat = position.latitude;
        long = position.longitude;

        List<geocoding.Placemark> placemarks =
            await geocoding.placemarkFromCoordinates(lat, long);
        print('latlong: $lat, $long');

        String address = placemarks[0].street! + " " + placemarks[0].country!;
      }
    } on Exception catch (e) {
      print("Exception geolocator section: $e");
    }

    print('latlong: $lat, $long');

    //     //--------------------Api Hit Logic-----------------------------

    if (lat != 0.0 && long != 0.0) {
      if (location == "") {
        location = "$lat|$long|$address";
      } else {
        location = "$location||$lat|$long|$address";
      }
    }

    print(
        "#################################location$location##########################");

    // service.sendData(
    //   {
    //     //"current_date": DateTime.now().toIso8601String(),
    //   },
    // );
    //     //-------------------------------------------------
  });
  Timer.periodic(Duration(minutes: 15), (timer) async {
    var body = await ApiCall().timeTracker(location);
    // print(body["status"]);
    if (body["status"] == "Success") {
      location = "";
    } else {
      Fluttertoast.showToast(msg: "failed");
      location = "";
    }
  });
}
