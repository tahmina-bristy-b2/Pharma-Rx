import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharma_rx/models/hive_data_model.dart';
import 'package:pharma_rx/ui/pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

double lat = 0.0;
double long = 0.0;
String location = "";
String address = "";
var timer_flag;
bool sync = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RxDcrDataModelAdapter());
  Hive.registerAdapter(MedicineListModelAdapter());
  await Hive.openBox('doctorList');
  await Hive.openBox<RxDcrDataModel>('RxdDoctor');
  await Hive.openBox<MedicineListModel>('draftMdicinList');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  timer_flag = prefs.getBool("timer_flag");
//   Location location = Location();
//   // location.enableBackgroundMode();
//   late bool _serviceEnabled;
//   late PermissionStatus _permissionGranted;

//   _serviceEnabled = await location.serviceEnabled();
//   if (!_serviceEnabled) {
//     _serviceEnabled = await location.requestService();
//     if (!_serviceEnabled) {
//       return;
//     }
//   }

//   _permissionGranted = await location.hasPermission();
//   if (_permissionGranted == PermissionStatus.denied) {
//     _permissionGranted = await location.requestPermission();
//     if (_permissionGranted != PermissionStatus.granted) {
//       return;
//     }
//   }

// //------------------------------------------------------

//   print("flag ashtse ${timer_flag}");

//   if (_serviceEnabled &&
//       _permissionGranted == PermissionStatus.granted &&
//       timer_flag == true) {
//     //await initializeService();

//     BGservice.serviceOn();
//     print('Starting Background Service...');

//     print('Starting Background Service...');
//   }
  runApp(const MyApp());
}

// class BGservice {
//    static Future<void> serviceOn() async {
//     await initializeService();
//   }
// }

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will executed when app is in foreground or background in separated isolate
//       onStart: onStart,

//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,

//       // this will executed when app is in foreground in separated isolate
//       onForeground: onStart,

//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
//   service.startService();
// }

// FutureOr<bool> onIosBackground(ServiceInstance service) {
//   WidgetsFlutterBinding.ensureInitialized();
//   print('FLUTTER BACKGROUND FETCH');
//   return true;
// }

// void onStart(ServiceInstance service) {
//   DartPluginRegistrant.ensureInitialized();

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
//   //********************Loop start********************
//   Timer.periodic(const Duration(seconds: 3), (timer) async {
//     // if (!(await service.isServiceRunning())) timer.cancel();

//     // //     //------------Internet Connectivity Check---------------------------
//     // final bool isConnected = await InternetConnectionChecker().hasConnection;
//     // print('Internet connection: $isConnected');
//     // // // ----------------------------------------------------------------------
//     // //     //----------------Set Notification------------------
//     // if (isConnected) {
//     //   service.setNotificationInfo(
//     //     title: "mRep7",
//     //     content: "Updated at ${DateTime.now()}",
//     //   );
//     // } else {
//     //   service.setNotificationInfo(
//     //     title: "mRep7",
//     //     content: "Updated at ${DateTime.now()}",
//     //   );
//     // }

//     //     //------------------------Geo Location-----------------

//     try {
//       geo.Position? position = await geo.Geolocator.getCurrentPosition();
//       if (position != null) {
//         lat = position.latitude;
//         long = position.longitude;

//         List<geocoding.Placemark> placemarks =
//             await geocoding.placemarkFromCoordinates(lat, long);

//         address = placemarks[0].street! + " " + placemarks[0].country!;
//       }
//     } on Exception catch (e) {
//       print("Exception geolocator section: $e");
//     }

//     print('latlong: $lat, $long');

//     //     //--------------------Api Hit Logic-----------------------------

//     if (lat != 0.0 && long != 0.0) {
//       if (location == "") {
//         location = "$lat|$long|$address";
//       } else {
//         location = "$location||$lat|$long|$address";
//       }
//     }

//     print(location);

//     // service.sendData(
//     //   {
//     //     //"current_date": DateTime.now().toIso8601String(),
//     //   },
//     // );
//     //     //-------------------------------------------------
//   });
//   Timer.periodic(Duration(minutes: 15), (timer) async {
//     var body = await ApiCall().timeTracker(location);
//     // print(body["status"]);
//     if (body["status"] == "Success") {
//       location = "";
//     } else {
//       Fluttertoast.showToast(msg: "failed");
//       location = "";
//     }
//   });
// }
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharma Rx',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
