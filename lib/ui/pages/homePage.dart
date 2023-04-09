import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoding/geocoding.dart' as geocoding;

import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:location/location.dart';
import 'package:pharma_rx/main.dart';
import 'package:pharma_rx/models/boxes.dart';
import 'package:pharma_rx/models/dmpath_data_model.dart';
import 'package:pharma_rx/models/login_data_model.dart';
import 'package:pharma_rx/models/others_data_model.dart';
import 'package:pharma_rx/services/apiCall.dart';
import 'package:pharma_rx/ui/pages/Rx/notice_screen.dart';
import 'package:pharma_rx/ui/pages/Rx/rx_draft_screen.dart';
import 'package:pharma_rx/ui/pages/Rx/rx_screen.dart';
import 'package:pharma_rx/ui/pages/Rx/rx_report_screen.dart';
import 'package:pharma_rx/ui/pages/attendance_page.dart';
import 'package:pharma_rx/ui/pages/drawer/reset_password_screen.dart';
import 'package:pharma_rx/ui/pages/loginPage.dart';
import 'package:pharma_rx/ui/pages/sync_data_tab_page.dart';
import 'package:pharma_rx/ui/widgets/home_widget_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

var tempdocName = "";
String areaName = "";
String areaid = "";
String address = "";
String docId = "";

class MyHomePage extends StatefulWidget {
  String userName;
  String user_id;
  // String startTime;
  // String endTime;

  MyHomePage(
      {Key? key,
      // required this.startTime,
      // required this.endTime,
      required this.userName,
      required this.user_id})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Box? box;
  DmPathDataModel? dmPathData;
  LoginDataModel? loginDataInfo;
  OthersDataModel? othersData;
  Box<OthersDataModel>? anotherOtherData;

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List data = [];
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  //String report_url = '';
  //String medicine_rx_url = '';
  //String cid = '';
  //String userId = '';
  //String userPassword = '';
  String deviceId = "";
  //String plugin_url = "";
  //String? areaPage;
  //String? userName;
  String? startTime;
  //String? user_id;
  String mobile_no = '';
  String? endTime;
  String version = '101';
  bool isLoading = true;
  //bool notice_flag = false;
  //var timer_flag;

  Location location = Location();
  // location.enableBackgroundMode();

  @override
  void initState() {
    super.initState();
    dmPathData = Boxes.getDmPathDataModel().get('dmPathData');
    loginDataInfo = Boxes.getLoginDataModel().get('userInfo');
    othersData = Boxes.getOthersDataModel().get('others');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedPreferences.getInstance().then((prefs) {
        startTime = othersData!.startTime;
        endTime = othersData!.endTime;

        deviceId = prefs.getString("deviceId") ?? " ";
        mobile_no = prefs.getString("mobile_no") ?? '';

        setState(() {
          int space = startTime!.indexOf(" ");
          String removeSpace =
              startTime!.substring(space + 1, startTime!.length);
          startTime = removeSpace.replaceAll("'", '');
          int space1 = endTime!.indexOf(" ");
          String removeSpace1 = endTime!.substring(space1 + 1, endTime!.length);
          endTime = removeSpace1.replaceAll("'", '');
        });
      });

//------------------------------------------------------

//------------------------------------------------------

      getPermission();

      setState(() {});
    });
  }

  getPermission() async {
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

    setState(() {});
  }

  int _currentSelected = 0;
  _onItemTapped(int index) async {
    if (index == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => RxScreen(
                    address: '',
                    areaId: '',
                    areaName: '',
                    ck: '',
                    dcrKey: 0,
                    docId: '',
                    docName: '',
                    uniqueId: 0,
                    draftRxMedicinItem: [],
                    image1: '',
                  )));
      setState(() {
        _currentSelected = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return
        // isLoading
        //     ? Container(
        //         padding: const EdgeInsets.all(50),
        //         color: Colors.white,
        //         child: const Center(
        //           child: CircularProgressIndicator(),
        //         ),
        //       )
        //     :
        SafeArea(
      child: Scaffold(
        key: _drawerKey,
        endDrawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll,
          // through the options in the drawer if there isn't enough vertical,
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 138, 201, 149)),
                child: Image.asset(
                  'assets/images/mRep7_logo.png',
                  color: Colors.black,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.sync_outlined, color: Colors.black),
                title: const Text('Sync Data'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SyncDataTabPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.vpn_key, color: Colors.black),
                title: const Text('Change password'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ResetPasswordScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.black),
                title: const Text('Logout'),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();

                  anotherOtherData = Boxes.getOthersDataModel();
                  anotherOtherData!.toMap().forEach((key, value) {
                    value.userPass = '';
                    value.endTime = '';
                    value.startTime = '';
                    anotherOtherData!.put(key, value);
                  });

                  // await prefs.setString('USER_ID', '');
                  // await prefs.setString('PASSWORD', '');

                  //prefs.clear();

                  //old task
                  await prefs.setString('CID', othersData!.cid);

                  // othersData!.box!.put('cid', othersData!.cid);
                  // othersData!.box!.put('user_pass', '');
                  // loginDataInfo!.box!.put('user_id', '');

                  // OthersDataModel(cid: "SKF", userPass: '');
                  // othersData.

                  print("Update Timer flage : ${loginDataInfo!.timerFlag}");

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 138, 201, 149),
          title: Text('MREPORTING v' + version),
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 27, 56, 34),
              fontWeight: FontWeight.w500,
              fontSize: 20),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: BottomNavigationBar(
          // type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          currentIndex: _currentSelected,
          // showUnselectedLabels: true,
          unselectedItemColor: Colors.grey[800],
          selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Text(""),
            ),
            BottomNavigationBarItem(
              label: 'Camera',
              icon: Icon(Icons.photo_camera_outlined),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // User information Section..............................................

                Container(
                  height: screenHeight / 9,
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromARGB(255, 222, 237, 250),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: const Color(0xFFDDEBF7),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            widget.userName,

                                            // ' $userName',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          'ID: ' + widget.user_id,
                                          // ' $userName',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              // Expanded(
                              //   flex: 3,
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(5.0),
                              //     child: Column(
                              //       // mainAxisAlignment: MainAxisAlignment.start,
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         GestureDetector(
                              //           onTap: (() {
                              //             // Navigator.push(
                              //             //     context,
                              //             //     MaterialPageRoute(
                              //             //         builder: (context) =>
                              //             //             const AttendanceScreen()));
                              //           }),
                              //           child: Text(
                              //             '[Attendance]' +
                              //                 '\n' +
                              //                 'Start: ' +
                              //                 startTime.toString() +
                              //                 '\n' +
                              //                 "End: " +
                              //                 endTime.toString(),
                              //             style: const TextStyle(
                              //               color: Colors.black,
                              //               fontSize: 18,
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: (() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AttendanceScreen()));
                                }),
                                child: FittedBox(
                                  child: Text(
                                    '[Attendance]' +
                                        '\n' +
                                        'Start: ' +
                                        startTime.toString() +
                                        '\n' +
                                        "End: " +
                                        endTime.toString(),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 15, 53, 85),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                // New Rx section.......................................

                Container(
                  color: const Color(0xFFE2EFDA),
                  height: screenHeight / 3.5,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomHomeButton(
                                  icon: Icons.camera_alt_sharp,
                                  onClick: () {
                                    // setState(() {
                                    //   isLoading = true;
                                    // });
                                    // getArea();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RxScreen(
                                                address: '',
                                                areaId: '',
                                                areaName: '',
                                                ck: '',
                                                dcrKey: 0,
                                                docId: '',
                                                docName: '',
                                                uniqueId: 0,
                                                draftRxMedicinItem: [],
                                                image1: '',
                                              )),
                                    );
                                  },
                                  title: 'RX Capture',
                                  sizeWidth: screenWidth,
                                  inputColor:
                                      const Color(0xff70BA85).withOpacity(.3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomHomeButton(
                                  icon: Icons.drafts_rounded,
                                  onClick: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RxDraftScreen(),
                                      ),
                                    );
                                  },
                                  title: 'Draft RX',
                                  sizeWidth: screenWidth,
                                  inputColor: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: CustomHomeButton(
                                  icon: Icons.insert_drive_file,
                                  onClick: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RxReportScreen(
                                          cid: othersData!.cid,
                                          userId: loginDataInfo!.userId,
                                          userPassword: othersData!.userPass,
                                          report_url: dmPathData!.reportRxUrl,
                                        ),
                                      ),
                                    );
                                  },
                                  title: 'RX Report',
                                  sizeWidth: screenWidth,
                                  inputColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Container(
                  color: const Color(0xFFE2EFDA),
                  height: screenHeight / 6,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              loginDataInfo!.noticeFlag
                                  ? Expanded(
                                      child: CustomHomeButton(
                                        icon: Icons.note_alt,
                                        onClick: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NoticeScreen()));
                                        },
                                        title: 'Notice',
                                        sizeWidth: screenWidth,
                                        inputColor: Colors.white,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: CustomHomeButton(
                                  onClick: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AttendanceScreen()));
                                  },
                                  icon: Icons.assignment_turned_in_sharp,
                                  title: 'Attendance',
                                  sizeWidth: screenWidth,
                                  inputColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                Container(
                  color: const Color(0xFFE2EFDA),
                  height: screenHeight / 7,
                  width: screenWidth,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomHomeButton(
                              icon: Icons.sync,
                              onClick: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const SyncDataTabPage()));
                              },
                              title: 'Sync Data',
                              sizeWidth: screenWidth,
                              inputColor: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Link(
                                uri: Uri.parse(
                                    '${dmPathData!.pluginUrl}?cid=${othersData!.cid}&rep_id=${loginDataInfo!.userId}&rep_pass=${othersData!.userPass}'),
                                target: LinkTarget.blank,
                                builder:
                                    (BuildContext ctx, FollowLink? openLink) {
                                  print(
                                      'plugin====${dmPathData!.pluginUrl}?cid=${othersData!.cid}&rep_id=${loginDataInfo!.userId}&rep_pass=${othersData!.userPass}');
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        backgroundColor: Colors.white,
                                        fixedSize: Size(
                                            screenWidth, screenHeight / 8)),
                                    onPressed: openLink,
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          "assets/images/rx.jfif",
                                          height: 30,
                                          width: 30,
                                          // color: Colors.black,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        const Text(
                                          "Plugin",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          )
                          // Expanded(
                          //   child: CustomHomeButton(
                          //     icon: ,
                          //     onClick: () {
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (_) =>
                          //                   const SyncDataTabPage()));
                          //     },
                          //     title: 'Plugin',
                          //     sizeWidth: screenWidth,
                          //     inputColor: Colors.white,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitToastforOrder2() {
    Fluttertoast.showToast(
        msg: 'Wrong user Id and Password',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
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

        address = placemarks[0].street! + " " + placemarks[0].country!;
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

    print(location);

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
