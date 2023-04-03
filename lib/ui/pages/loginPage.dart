// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pharma_rx/models/boxes.dart';
import 'package:pharma_rx/models/dmpath_data_model.dart';
import 'package:pharma_rx/services/sharedPrefernce.dart';
import 'package:pharma_rx/ui/pages/homePage.dart';
import 'package:pharma_rx/ui/pages/sync_data_tab_page.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

// List regionList = [];
List region_List = [];
List<String> rxTypeList = [];
bool? timer_flag;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _companyIdController = TextEditingController();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double screenHeight = 0;
  double screenWidth = 0;
  Color initialColor = Colors.white;
  bool _obscureText = true;
  List dcrDataList = [];
  Box? box;

  String login_url = '';
  String deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  bool isLoading = false;
  String version = 'V101';

  @override
  initState() {
    super.initState();

    _getDeviceInfo();

    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString("CID") != null) {
        var a = prefs.getString("CID");
        setState(() {
          _companyIdController.text = a.toString();
        });
      }
    });
  }

  Future _getDeviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();

    var androidDeviceInfo = await deviceInfo.androidInfo;
    // deviceId = androidDeviceInfo.id!;

    deviceBrand = androidDeviceInfo.brand!;
    deviceModel = androidDeviceInfo.model!;
    try {
      deviceId = (await PlatformDeviceId.getDeviceId)!;
      // print(deviceId);
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceId', deviceId);
    await prefs.setString('deviceBrand', deviceBrand!);
    await prefs.setString('deviceModel', deviceModel!);
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return isLoading
        ? Container(
            padding: const EdgeInsets.all(50),
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: const Color(0xFFE2EFDA),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: screenHeight / 3.5,
                      width: screenWidth,
                      child: Center(
                        child: SizedBox(
                          width: 220,
                          height: 180,
                          child: Image.asset(
                            'assets/images/mRep7_wLogo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight - screenHeight / 2.3,
                      width: screenWidth,
                      color: const Color(0xFFE2EFDA),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth / 60),
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight / 40,
                            ),
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenWidth / 10,
                                    horizontal: screenWidth / 28),
                                child: Column(
                                  children: [
                                    // Company ID Field
                                    TextFormField(
                                      autofocus: false,
                                      controller: _companyIdController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        labelText: 'Company Id',
                                        labelStyle: TextStyle(
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Provide Your valid CompanyId';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),

                                    SizedBox(
                                      height: screenHeight / 50,
                                    ),

                                    // User Id field
                                    TextFormField(
                                      autofocus: false,
                                      controller: _userIdController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        labelText: 'User Id',
                                        labelStyle: TextStyle(
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Provide Your User Id';
                                        }
                                        if (value.contains("@")) {
                                          return 'Please Provide Your Valid User Id';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: screenHeight / 50,
                                    ),

                                    // Password Field
                                    TextFormField(
                                      obscureText: _obscureText,
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.vpn_key,
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        suffixIcon: _obscureText == true
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(
                                                    () {
                                                      _obscureText = false;
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.visibility_off,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ))
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _obscureText = true;
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.remove_red_eye,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.done,
                                      validator: (value) {
                                        // RegExp regexp = RegExp(r'^.{6,}$');
                                        if (value!.isEmpty) {
                                          return 'Please enter your password.';
                                        }
                                        // if (value.length >= 6) {
                                        //   return 'Password is too short ,please expand';
                                        // }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: screenHeight / 60),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4,
                              height: screenWidth / 10,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    bool result =
                                        await InternetConnectionChecker()
                                            .hasConnection;
                                    if (result == true) {
                                      login_url = await dmPath(
                                          deviceId,
                                          deviceBrand,
                                          deviceModel,
                                          _companyIdController.text
                                              .toUpperCase(),
                                          _userIdController.text,
                                          _passwordController.text,
                                          context);
                                      if (login_url == "") {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      } else {
                                        login(
                                            deviceId,
                                            deviceBrand,
                                            deviceModel,
                                            cid,
                                            _userIdController.text,
                                            _passwordController.text,
                                            login_url,
                                            context);
                                      }

                                      // SharedPreferncesMethod()
                                      //     .sharedPreferenceSetDataForLogin(
                                      //         _companyIdController.text
                                      //             .toUpperCase(),
                                      //         _userIdController.text,
                                      //
                                      //     _passwordController.text);
                                    }

//==============================================================================================
                                    // if (result == true) {
                                    //   dmPath(
                                    //       deviceId,
                                    //       deviceBrand,
                                    //       deviceModel,
                                    //       _companyIdController.text
                                    //           .toUpperCase(),
                                    //       _userIdController.text,
                                    //       _passwordController.text,
                                    //       context);

                                    //   // SharedPreferncesMethod()
                                    //   //     .sharedPreferenceSetDataForLogin(
                                    //   //         _companyIdController.text
                                    //   //             .toUpperCase(),
                                    //   //         _userIdController.text,
                                    //   //
                                    //   //     _passwordController.text);
                                    // }

                                    else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      _submitToastforOrder3();

                                      // print(InternetConnectionChecker()
                                      //     .lastTryResults);
                                    }
                                  } else {}
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        SizedBox(
                          width: screenWidth / 2.5,
                          // height: screenHeight / 10,
                          child: Text(
                            "v-${version}-20230129",
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 107, 170, 221)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }

  // Dm Path and Login function................
  Future<String> dmPath(
      String? deviceId,
      String? deviceBrand,
      String? deviceModel,
      String cid,
      String userId,
      String password,
      BuildContext context) async {
    final dmpathBox = Boxes.getDmPathDataModel();
    DmPathDataModel dmPathDataModelData;
    String loginUrl = '';

    try {
      final http.Response response = await http.get(
        Uri.parse(
            'http://w03.yeapps.com/dmpath/dmpath_rx_101/get_dmpath?cid=$cid'),
      );

      // final Map<String, dynamic> jsonresponse = json.decode(response.body);

      var userInfo = json.decode(response.body);
      print("userinfo ashbe from loginpage ${userInfo}");
      var status = userInfo['res_data'];

      if (status['ret_res'] == 'Welcome to mReporting.') {
        _submitToastforOrder1();

        setState(() {
          isLoading = false;
        });
        return loginUrl;
      } else {
        dmPathDataModelData = dmPathDataModelFromJson(jsonEncode(status));
        dmpathBox.put('dmpathData', dmPathDataModelData);
        loginUrl = status['login_url'] ?? '';

        login_url = status['login_url'];

        String area_url = status['area_url'];
        String submit_atten_url = status['submit_atten_url'] ?? "";
        String doctor_url = status['doctor_url'];
        String submit_rx_url = status['submit_rx_url'];
        String report_rx_url = status['report_rx_url'];
        String submit_photo_url = status['submit_photo_url'];
        String medicine_rx_url = status['medicine_rx_url'];
        String change_pass_url = status['change_pass_url'];
        String timer_track_url = status['timer_track_url'];
        String plugin_url = status['plugin_url'];
        String sync_notice_url = status['sync_notice_url'];
        // String photo_url = status['photo_url'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('submit_atten_url', submit_atten_url);

        await prefs.setString('medicine_rx_url', medicine_rx_url);
        await prefs.setString('area_url', area_url);
        await prefs.setString('doctor_url', doctor_url);
        await prefs.setString('submit_rx_url', submit_rx_url);
        await prefs.setString('report_rx_url', report_rx_url);
        await prefs.setString('submit_photo_url', submit_photo_url);
        await prefs.setString('change_pass_url', change_pass_url);
        await prefs.setString('timer_track_url', timer_track_url);
        await prefs.setString('plugin_url', plugin_url);
        await prefs.setString('sync_notice_url', sync_notice_url);

        // await prefs.setString('photo_url', photo_url);

        login(deviceId, deviceBrand, deviceModel, cid, userId, password,
            login_url, context);
        return loginUrl;
      }

      // return isLoading;
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
  }

  Future login(
      String? deviceId,
      String? deviceBrand,
      String? deviceModel,
      String cid,
      String userId,
      String password,
      String loginUrl,
      BuildContext context) async {
    List dcrDataList = [];
    String status = '';
    try {
      print(
          '$login_url?cid=$cid&user_id=$userId&user_pass=$password&device_id=$deviceId&device_brand=$deviceBrand&device_model=$deviceModel&app_v=$version');
      final http.Response response = await http.get(Uri.parse(
          '$login_url?cid=$cid&user_id=$userId&user_pass=$password&device_id=$deviceId&device_brand=$deviceBrand&device_model=$deviceModel&app_v=$version'));
      //   Uri.parse(
      //       '$loginUrl?cid=$cid&user_id=$userId&user_pass=$password&device_id=$deviceId&device_brand=$deviceBrand&device_model=$deviceModel' +
      //           '_$version'),
      // );

      // final Map<String, dynamic> jsonresponse = json.decode(response.body);

      var userInfo = json.decode(response.body);
      print(userInfo);
      status = userInfo['status'];

      if (status == 'Success') {
        setState(() {
          isLoading = true;

          // print(isLoading);x
        });
        String userName = userInfo['user_name'];
        String user_id = userInfo['user_id'];
        String mobile_no = userInfo['mobile_no'];
        bool rxDocMustFlag = userInfo["rx_doc_must"];
        bool rxTypeMustFlag = userInfo["rx_type_must"];
        bool notice_flag = userInfo["notice_flag"];
        bool rxGalAllowFlag = userInfo["rx_gallery_allow"];
        timer_flag = userInfo["timer_flag"];
        print("Notice Flage          :$notice_flag");
        print(timer_flag);
        // List rx_type_list = userInfo["rx_type_list"];
        List rx_type_list = userInfo["rx_type_list"];
        rxTypeList.clear();
        rx_type_list.forEach((element) {
          rxTypeList.add(element);
        });
        print(rxTypeList);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('areaPage', userInfo['area_page'].toString());
        await prefs.setString('userName', userName);
        await prefs.setString('user_id', user_id);
        await prefs.setString('deviceId', deviceId!);
        await prefs.setString('deviceBrand', deviceBrand!);
        await prefs.setString('deviceModel', deviceModel!);
        await prefs.setString('version', version);
        await prefs.setString('mobile_no', mobile_no);
        await prefs.setBool('rxDocMustFlag', rxDocMustFlag);
        await prefs.setBool('rxTypeMustFlag', rxTypeMustFlag);
        await prefs.setBool('rxGalAllowFlag', rxGalAllowFlag);
        await prefs.setBool('timer_flag', timer_flag!);
        await prefs.setBool('notice_flag', notice_flag);
        await prefs.setStringList('rxTypeList', rxTypeList);

        SharedPreferncesMethod().sharedPreferenceSetDataForLogin(
            _companyIdController.text.toUpperCase(),
            _userIdController.text,
            _passwordController.text);

        Hive.openBox('MedicineList').then(
          (value) {
            // var mymap = value.toMap().values.toList();
            List dcrDataList = value.toMap().values.toList();
            print(dcrDataList.length);
            if (dcrDataList.isNotEmpty) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(
                    userName: userName,
                    user_id: user_id,
                  ),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const SyncDataTabPage(),
                ),
              );
            }
          },
        );
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MyHomePage(
        //       userName: userName,
        //       user_id: user_id,
        //     ),
        //   ),
        // );
        return status;
      } else {
        setState(() {
          isLoading = false;
        });
        _submitToastforOrder2();
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
  }

  void _submitToastforOrder1() {
    Fluttertoast.showToast(
        msg: 'Wrong CID',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
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

  void _submitToastforOrder3() {
    Fluttertoast.showToast(
        msg: 'No Internet Connection\nPlease check your internet connection.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
