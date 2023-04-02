import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pharma_rx/models/boxes.dart';
import 'package:pharma_rx/models/hive_data_model.dart';
import 'package:pharma_rx/ui/pages/Rx/doctor_list.dart';
import 'package:pharma_rx/ui/pages/Rx/doctor_list_screen.dart';
import 'package:pharma_rx/ui/pages/Rx/medicin_list_screen.dart';
import 'package:pharma_rx/ui/pages/homePage.dart';
import 'package:pharma_rx/ui/pages/loginPage.dart';
import 'package:pharma_rx/ui/widgets/show_case_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

var quantity = "";

List<RxDcrDataModel> getListForOrphan = [];

class RxScreen extends StatefulWidget {
  int dcrKey;
  int uniqueId;
  String ck;
  String docName;
  String docId;
  String areaName;
  String areaId;
  String address;
  String image1;
  List<MedicineListModel> draftRxMedicinItem;
  RxScreen(
      {Key? key,
      required this.address,
      required this.areaId,
      required this.ck,
      required this.dcrKey,
      required this.uniqueId,
      required this.docName,
      required this.docId,
      required this.areaName,
      required this.draftRxMedicinItem,
      required this.image1})
      : super(key: key);

  @override
  State<RxScreen> createState() => _RxScreenState();
}

class _RxScreenState extends State<RxScreen> {
  TextEditingController doctorController = TextEditingController();
  bool isSwitchedForOthers = false;
  bool isSwitchedForFF = false;
  bool isSwitchedForFS = false;

  late TransformationController controller;
  TapDownDetails? tapDownDetails;
  Box? box;
  List<RxDcrDataModel> getList = [];
  List doctorData = [];
  List medicineData = [];
  List<RxDcrDataModel> finalDoctorList = [];
  List<MedicineListModel> finalMedicineList = [];
  List finalDraftDoctorList = [];
  List finalDraftMedicineList = [];
  List rxMedicineDataList = [];
  List tempMedicineList = [];
  File? imagePath;
  XFile? file;
  String a = '';
  String? value;
  // File? _image;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  int _currentSelected = 3;
  int _currentSelected2 = 2;
  int counterForDoctor = 0;
  int _counterforRx = 0;
  var rxdropDownValue = "";
  String? submit_url;
  String? submit_photo_url;
  String? cid;
  String? userId;
  String? userPassword;
  String itemString = '';
  String userName = '';
  String user_id = '';
  String startTime = '';
  String endTime = '';
  int tempCount = 0;
  // String? docId;
  double? latitude = 0.0;
  double? longitude = 0.0;
  String? deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  bool _isLoading = true;
  bool _activeCounter = false;
  bool? rxDocMustFlag;
  bool? rxTypeMustFlag;
  bool? rxGalAllowFlag;
  List<String>? rxTypeList;
  String finalImage = '';
  String rxTypeValue = "";
  String submit_rx_url = "";
  //todo
  bool _isCameraClick = false;
  int objectImageId = 0;

  @override
  void initState() {
    print(finalMedicineList.length);
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        submit_photo_url = prefs.getString('submit_photo_url');
        latitude = prefs.getDouble("latitude");
        // print('lattitide:$latitude');
        longitude = prefs.getDouble("longitude");
        submit_rx_url = prefs.getString("submit_rx_url")!;

        cid = prefs.getString("CID");

        userId = prefs.getString("USER_ID");
        userPassword = prefs.getString("PASSWORD");
        userName = prefs.getString("userName")!;
        user_id = prefs.getString("user_id")!;
        deviceId = prefs.getString("deviceId");
        deviceBrand = prefs.getString("deviceBrand");
        deviceModel = prefs.getString("deviceModel");
        rxDocMustFlag = prefs.getBool("rxDocMustFlag");
        rxTypeMustFlag = prefs.getBool("rxTypeMustFlag");
        rxGalAllowFlag = prefs.getBool("rxGalAllowFlag");
        rxTypeList = prefs.getStringList("rxTypeList") ?? [];
      });
      print(rxTypeList);
      print(rxTypeMustFlag);
      if (prefs.getInt('RxCounter') != null) {
        int? a = prefs.getInt('RxCounter');
        setState(() {
          _counterforRx = a!;
        });
      } else {
        return;
      }
      // if (prefs.getInt('RxCounter') != null) {
      //   int? a = prefs.getInt('RxCounter');
      //   setState(() {
      //     _counterforRx = a!;
      //   });
      // }
    });

    if (widget.docId != '') {
      docId = widget.docId;
      counterForDoctor = widget.uniqueId;
    }

    finalMedicineList = widget.draftRxMedicinItem;
    tempCount = widget.draftRxMedicinItem.length;

    if (widget.ck == 'isCheck') {
      setState(() {
        _activeCounter = true;
      });
      //! Don't Understand

      int space = widget.image1.indexOf(" ");

      print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii$space");
      String removeSpace =
          widget.image1.substring(space + 1, widget.image1.length);
      finalImage = removeSpace.replaceAll("'", '');

      getList.add(RxDcrDataModel(
        uiqueKey: widget.uniqueId,
        docName: widget.docName,
        docId: widget.docId,
        areaId: widget.areaId,
        areaName: widget.areaName,
        address: widget.address,
        presImage: finalImage,
      ));

      //  finalDoctorList.add(RxDcrDataModel(
      //   uiqueKey: widget.uniqueId,
      //   docName: widget.docName,
      //   docId: widget.docId,
      //   areaId: widget.areaId,
      //   areaName: widget.areaName,
      //   address: widget.address,
      //   presImage: finalImage,
      // ));
    } else if (widget.ck == "isOrphan") {
      getList.clear();
      int space = widget.image1.indexOf(" ");

      print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii$space");

      String removeSpace =
          widget.image1.substring(space + 1, widget.image1.length);
      finalImage = removeSpace.replaceAll("'", '');

      getList.add(RxDcrDataModel(
        uiqueKey: widget.uniqueId,
        docName: widget.docName,
        docId: widget.docId,
        areaId: widget.areaId,
        areaName: widget.areaName,
        address: widget.address,
        presImage: widget.image1,
      ));
    }
    print("ddddddddddddddddddddddddddddddddddddddddd${widget.ck}");
    super.initState();
  }

  _sharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      submit_photo_url = prefs.getString('submit_photo_url');
      latitude = prefs.getDouble("latitude");
      // print('lattitide:$latitude');
      longitude = prefs.getDouble("longitude");
      submit_url = prefs.getString("submit_url")!;

      cid = prefs.getString("CID");

      userId = prefs.getString("USER_ID");
      userPassword = prefs.getString("PASSWORD");
      userName = prefs.getString("userName")!;
      user_id = prefs.getString("user_id")!;
      deviceId = prefs.getString("deviceId");
      deviceBrand = prefs.getString("deviceBrand");
      deviceModel = prefs.getString("deviceModel");
      rxDocMustFlag = prefs.getBool("rxDocMustFlag");
      rxTypeMustFlag = prefs.getBool("rxTypeMustFlag");
      rxGalAllowFlag = prefs.getBool("rxGalAllowFlag");
      rxTypeList = prefs.getStringList("rxTypeList")!;
    });

    // rxTypeList = prefs.getStringList("rxTypeList")!;

    if (prefs.getInt('RxCounter') != null) {
      int? a = prefs.getInt('RxCounter');
      setState(() {
        _counterforRx = a!;
      });
    } else {
      return;
    }
  }

  int _rxCounter() {
    var dt = DateFormat('HH:mm:ssss').format(DateTime.now());

    String time = dt.replaceAll(":", '');

    setState(() {
      _counterforRx = int.parse(time);
    });

    return _counterforRx;
  }

  void calculateRxItemString() {
    if (finalMedicineList.isNotEmpty) {
      finalMedicineList.forEach((element) {
        if (itemString == '') {
          itemString =
              element.itemId.toString() + '|' + element.quantity.toString();
        } else {
          // ignore: prefer_interpolation_to_compose_strings
          itemString += '||' +
              element.itemId.toString() +
              '|' +
              element.quantity.toString();
        }
      });
    }
    // if (finalMedicineList.isNotEmpty) {
    //   finalMedicineList.forEach((element) {
    //     print(element.itemId);
    //     if (itemString == '') {
    //       if (element.itemId.toString() == "0") {
    //         itemString = element.itemId.toString() +
    //             '|' +
    //             element.quantity.toString() +
    //             "|" +
    //             element.name.toString();
    //       } else {
    //         itemString = '${element.itemId}|${element.quantity}';
    //       }
    //     } else {
    //       if (element.itemId.toString() == "0") {
    //         itemString += '||' +
    //             element.itemId.toString() +
    //             '|' +
    //             element.quantity.toString() +
    //             "|" +
    //             element.name.toString();
    //       } else {
    //         itemString += '||${element.itemId}|${element.quantity}';
    //       }
    //     }
    //   });
    // }
  }

// CAREFULLY CHANGE THIS ONE=============================================================
  void _onItemTapped(int index) async {
    if (index == 0) {
      setState(() {
        _isLoading = false;
      });
      // orderSubmit();
      if ((widget.image1 != '' || imagePath != null) &&
          finalMedicineList.isNotEmpty) {
        bool result = await InternetConnectionChecker().hasConnection;
        if (result == true) {
          if (rxDocMustFlag == true) {
            //changes will come
            if (getList[0].docId != "") {
              _rxImageSubmit();
            } else {
              Fluttertoast.showToast(
                  msg: 'Please  SelectDoctor.',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              setState(() {
                _isLoading = true;
              });
            }
          } else {
            _rxImageSubmit();
          }
        } else {
          _submitToastforOrder3();
          setState(() {
            _isLoading = true;
          });
          // print(InternetConnectionChecker().lastTryResults);
        }
      } else {
        setState(() {
          _isLoading = true;
        });
        _submitToastforphoto();
      }

      setState(() {
        _currentSelected = index;
      });
    }
    if (index == 1) {
      _galleryFunctionality();
      setState(() {
        _currentSelected = index;
      });
    }

    if (index == 2) {
      if (imagePath != null || widget.image1 != '') {
        putAddedRxData();
      } else {
        _submitToastforphoto();
      }
      // putAddedRxData();

      setState(() {
        _currentSelected = index;
      });
    }

    if (index == 3) {
      _cameraFuntionality();
      setState(() {
        _currentSelected = index;
      });
    }
  }

  //==========================================================
// CAREFULLY CHANGE THIS ONE=============================================================
  void _onItemTapped2(int index) async {
    if (index == 0) {
      setState(() {
        _isLoading = false;
      });
      // orderSubmit();
      if ((widget.image1 != '' || imagePath != null) &&
          finalMedicineList.isNotEmpty) {
        bool result = await InternetConnectionChecker().hasConnection;
        if (result == true) {
          if (rxDocMustFlag == true) {
            if (getList[0].docId != "") {
              _rxImageSubmit();
            } else {
              _submitToastfoDoctor();
              setState(() {
                _isLoading = true;
              });
            }
          } else {
            _rxImageSubmit();
          }
        } else {
          _submitToastforOrder3();
          setState(() {
            _isLoading = true;
          });
          // print(InternetConnectionChecker().lastTryResults);
        }
      } else {
        setState(() {
          _isLoading = true;
        });
        _submitToastforMedicine();
      }

      setState(() {
        _currentSelected2 = index;
      });
    }

    if (index == 1) {
      if (imagePath != null || widget.image1 != '') {
        putAddedRxData();
      } else {
        _submitToastforphoto();
      }
      // putAddedRxData();

      setState(() {
        _currentSelected2 = index;
      });
    }

    if (index == 2) {
      _cameraFuntionality();
      setState(() {
        _currentSelected2 = index;
      });
    }
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

  void _submitToastfoDoctor() {
    Fluttertoast.showToast(
        msg: 'Please Select Doctor',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                userName: userName,
                user_id: user_id,
              ),
            ),
            (Route<dynamic> route) => false);
        throw ("e");
      },
      child: _isLoading
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 138, 201, 149),
                title: const Text('Rx Capture'),
                titleTextStyle: const TextStyle(
                    color: Color.fromARGB(255, 27, 56, 34),
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
                centerTitle: true,
                // title: const Text('Rx Capture'),
                leading: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                  userName: userName, user_id: user_id)));
                    },
                    icon: const Icon(Icons.home)),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //////////////////camera////////////////////
                      Row(
                        children: [
                          //////////////////camera////////////////////
                          Card(
                            elevation: 5,
                            child: Container(
                              height: screenHeight / 3.3,
                              width: screenWidth / 1.8,
                              decoration: const BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),
                              child: widget.image1 != ''
                                  ? InkWell(
                                      onDoubleTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ZoomForRxDraftImage(finalImage),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: "imageForDraft",
                                        child: Image.file(
                                          File(finalImage),
                                        ),
                                      ),
                                    )
                                  : file == null
                                      ? Column(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Image.asset(
                                                'assets/images/default_document.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Expanded(
                                                // flex: 4,
                                                child: Container(
                                              width: screenWidth / 1.8,
                                              color: Colors.white,
                                              child: const Center(
                                                child: Text(
                                                  "Double tap to zoom",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            ))
                                          ],
                                        )
                                      : InkWell(
                                          onDoubleTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ZoomForRxImage(imagePath),
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag: "img",
                                            child: Image.file(imagePath!),
                                          ),
                                        ),
                            ),
                          ),
                          //////////////////camera////////////////////
                          const SizedBox(
                            width: 50,
                          ),
                          Center(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //todo  work here
                                    if (imagePath != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DoctorScreen(
                                            getList: (value) {
                                              setState(() {
                                                getList = value
                                                    as List<RxDcrDataModel>;
                                                getList.forEach((element) {
                                                  docId = element.docId;
                                                  tempdocName = element.docName;
                                                  areaName = element.areaName;
                                                  areaid = element.areaId;
                                                  address = element.address;
                                                });
                                              });
                                            },
                                            counterCallback: (value) {
                                              counterForDoctor = value;

                                              setState(() {});
                                            },
                                            counterForDoctorList:
                                                widget.uniqueId > 0
                                                    ? widget.uniqueId
                                                    : _isCameraClick == true
                                                        ? objectImageId
                                                        : _counterforRx,
                                            // widget.uniqueId > 0
                                            //     ? widget.uniqueId
                                            //     : _activeCounter == true
                                            //         ? _counterforRx
                                            //         : counterForDoctor,
                                            orphanImg: imagePath.toString(),
                                            medicine: finalMedicineList,
                                          ),
                                        ),
                                      );
                                    } else if (widget.image1 != '') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DoctorScreen(
                                            medicine: finalMedicineList,
                                            getList: (value) {
                                              setState(() {
                                                getList = value
                                                    as List<RxDcrDataModel>;
                                                getList.forEach((element) {
                                                  docId = element.docId;
                                                  tempdocName = element.docName;
                                                  areaName = element.areaName;
                                                  areaid = element.areaId;
                                                  address = element.address;
                                                });
                                              });
                                            },
                                            counterCallback: (value) {
                                              counterForDoctor = value;

                                              setState(() {});
                                            },
                                            counterForDoctorList:
                                                widget.uniqueId > 0
                                                    ? widget.uniqueId
                                                    : _activeCounter == true
                                                        ? _counterforRx
                                                        : counterForDoctor,
                                            orphanImg: widget.image1,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Please Take Image First ',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }

                                    // getRxDoctorData();
                                  },
                                  child: Center(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      elevation: 5,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color: Colors.white,
                                                ),
                                                width: screenWidth / 5,
                                                height: screenHeight / 9.5,

                                                // color: const Color(0xffDDEBF7),
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/doctor.png',
                                                        // color: Colors.teal,
                                                        width: screenWidth / 7,
                                                        height: screenWidth / 7,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      FittedBox(
                                                        child: Text(
                                                          'Doctor',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.teal,
                                                            fontSize:
                                                                screenHeight /
                                                                    45,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //todo abubakarkad
                                    setState(() {});
                                    if (imagePath != null) {
                                      if (widget.uniqueId >= 0 &&
                                          getList.isNotEmpty) {
                                        getMedicine();
                                        // print(widget.uniqueId);
                                      } else if (_activeCounter == false) {
                                        _rxCounter();
                                        getMedicine();
                                        // print('test:${widget.uniqueId}');
                                        setState(() {
                                          _activeCounter = true;
                                        });
                                      } else if (_activeCounter == true) {
                                        getMedicine();
                                      }
                                    } else if (widget.image1 != '') {
                                      if (widget.uniqueId >= 0 &&
                                          getList.isNotEmpty) {
                                        //todo abu getmedicen
                                        getMedicine();
                                        // print(widget.uniqueId);
                                      } else if (_activeCounter == false) {
                                        _rxCounter();
                                        getMedicine();
                                        // print('test:${widget.uniqueId}');
                                        setState(() {
                                          _activeCounter = true;
                                        });
                                      } else if (_activeCounter == true) {
                                        getMedicine();
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Please Take Image First ',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                  child: Center(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      elevation: 5,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: screenWidth / 5,
                                                height: screenHeight / 9.5,
                                                color: Colors.white,
                                                // color: const Color(0xffDDEBF7),
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/cap.png',
                                                        // color: Colors.teal,
                                                        width: screenWidth / 10,
                                                        height: screenWidth / 8,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      FittedBox(
                                                        child: Text(
                                                          'Medicine',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.teal,
                                                            fontSize:
                                                                screenHeight /
                                                                    45,
                                                          ),
                                                        ),
                                                      )
                                                      // Image.asset(
                                                      //   'assets/images/doctor.jpg',
                                                      //   // width: 60,
                                                      //   // height: 40,
                                                      //   fit: BoxFit.cover,
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //////////////////doctor info/////////////////
                      getList.isNotEmpty
                          ? SizedBox(
                              height: screenHeight / 8.9,
                              child: Card(
                                color: const Color(0xffDDEBF7),
                                elevation: 10,
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white70, width: 1),
                                  // borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  height: 90,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffDDEBF7),
                                    //borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 10,
                                                    child: Text(
                                                      "${getList[0].docName}",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '${getList[0].areaName}(${getList[0].areaId}) , ${getList[0].address}',
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        rxTypeMustFlag == true
                                            ? Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            DropdownButtonFormField(
                                                          icon: const Icon(
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: Colors.black,
                                                          ),

                                                          // Array list of items
                                                          items: rxTypeList
                                                              ?.map((items) {
                                                            return DropdownMenuItem(
                                                              value: items,
                                                              child: Text(
                                                                items,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),

                                                          onChanged:
                                                              (newValue) {
                                                            setState(() {
                                                              this.value =
                                                                  newValue
                                                                      as String;

                                                              rxdropDownValue =
                                                                  newValue;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: screenHeight / 8.9,
                              child: Card(
                                color: const Color(0xffDDEBF7),
                                elevation: 10,
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white70, width: 1),
                                  // borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffDDEBF7),
                                    //borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: tempdocName == ""
                                              ? const Text(
                                                  'No Doctor Selected',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                )
                                              : Text(
                                                  tempdocName,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                        ),
                                        rxTypeMustFlag == true
                                            ? Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            DropdownButtonFormField(
                                                          icon: const Icon(
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: Colors.black,
                                                          ),

                                                          // Array list of items
                                                          items: rxTypeList
                                                              ?.map((items) {
                                                            return DropdownMenuItem(
                                                              value: items,
                                                              child: Text(
                                                                items,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),

                                                          onChanged:
                                                              (newValue) {
                                                            setState(() {
                                                              value = newValue
                                                                  as String;

                                                              rxdropDownValue =
                                                                  newValue;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                      Container(
                        height: screenHeight / 14,
                        decoration: const BoxDecoration(
                          color: Color(0xffDDEBF7),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // const SizedBox(
                                  //   width: 10,
                                  // ),
                                  const Text("FF  Present"),
                                  Switch(
                                    value: isSwitchedForFF,
                                    onChanged: (value) {
                                      setState(() {
                                        isSwitchedForFF = value;
                                      });
                                    },
                                    activeTrackColor: Colors.teal,
                                    activeColor:
                                        const Color.fromARGB(255, 67, 126, 120),
                                  ),
                                  // const SizedBox(
                                  //   width: 15,
                                  // ),
                                  const Text("Manager"),
                                  Switch(
                                    value: isSwitchedForFS,
                                    onChanged: (value) {
                                      setState(() {
                                        isSwitchedForFS = value;
                                      });
                                    },
                                    activeTrackColor: Colors.teal,
                                    activeColor:
                                        const Color.fromARGB(255, 67, 126, 120),
                                  ),
                                  // const SizedBox(
                                  //   width: 15,
                                  // ),
                                  const Text("Others"),
                                  Switch(
                                    value: isSwitchedForOthers,
                                    onChanged: (value) {
                                      setState(() {
                                        isSwitchedForOthers = value;
                                      });
                                    },
                                    activeTrackColor: Colors.teal,
                                    activeColor:
                                        const Color.fromARGB(255, 67, 126, 120),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ////////////////////////////////medicine List View////////////////
                      finalMedicineList.isNotEmpty
                          ? Card(
                              elevation: 15,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white70, width: 1),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              color: const Color(0xffDDEBF7),
                              child: SizedBox(
                                height: screenHeight / 1.5,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: finalMedicineList.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext itemBuilder, index) {
                                    return Card(
                                      elevation: 10,
                                      color: const Color.fromARGB(
                                          255, 217, 248, 219),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.white70, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: -9,
                                                right: 0,
                                                child: IconButton(
                                                  // color: Colors.red,
                                                  onPressed: () {
                                                    _showMyDialog(index);
                                                  },
                                                  icon: const Icon(
                                                    Icons.clear,
                                                    // size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Spacer(),

                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            '${finalMedicineList[index].name} ' +
                                                                '(${finalMedicineList[index].itemId})',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontWeight:
                                                              // FontWeight.bold,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            // var y =
                                                            if (finalMedicineList[
                                                                        index]
                                                                    .quantity >
                                                                1) {
                                                              finalMedicineList[
                                                                      index]
                                                                  .quantity--;
                                                            }

                                                            // calculateRxItemString(
                                                            //     y.toString());
                                                            setState(() {});
                                                          },
                                                          icon: const Icon(
                                                              Icons.remove),
                                                        ),
                                                        Container(
                                                          width: 40,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .blueAccent)),
                                                          // color: !pressAttention
                                                          //     ? Colors.white
                                                          //     : Colors.blueAccent,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    8,
                                                                    0,
                                                                    0),
                                                            child: Text(
                                                              finalMedicineList[
                                                                      index]
                                                                  .quantity
                                                                  .toString(),
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              // var x =
                                                              finalMedicineList[
                                                                      index]
                                                                  .quantity++;
                                                              // calculateRxItemString(
                                                              //     x.toString());
                                                              setState(() {});
                                                            },
                                                            icon: const Icon(
                                                                Icons.add)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    );
                                  },
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 5,
                            ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: rxGalAllowFlag == true
                  ? BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      onTap: _onItemTapped,
                      currentIndex: _currentSelected,
                      showUnselectedLabels: true,
                      unselectedItemColor: Colors.grey[800],
                      selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          label: 'Submit',
                          icon: Icon(Icons.save),
                        ),
                        BottomNavigationBarItem(
                          label: 'Gallery',
                          icon: Icon(Icons.add_photo_alternate),
                        ),
                        BottomNavigationBarItem(
                          label: 'Save Drafts',
                          icon: Icon(Icons.drafts),
                        ),
                        BottomNavigationBarItem(
                          label: 'Camera',
                          icon: Icon(Icons.camera_alt),
                        ),
                      ],
                    )
                  : BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      onTap: _onItemTapped2,
                      currentIndex: _currentSelected2,
                      showUnselectedLabels: true,
                      unselectedItemColor: Colors.grey[800],
                      selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          label: 'Submit',
                          icon: Icon(Icons.save),
                        ),
                        BottomNavigationBarItem(
                          label: 'Save Drafts',
                          icon: Icon(Icons.drafts),
                        ),
                        BottomNavigationBarItem(
                          label: 'Camera',
                          icon: Icon(Icons.camera_alt),
                        ),
                      ],
                    ),
            )
          : Container(
              padding: const EdgeInsets.all(100),
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  // rx Submitt................................................
  Future<dynamic> rxSubmit(String fileName) async {
    var dt = DateFormat('HH:mm:ss').format(DateTime.now());

    String time = dt.replaceAll(":", '');
    String a = '${user_id}_$time';

    var cidforSubmit = cid;
    var userIdforSubmit = userId;
    var userpassforSubmit = userPassword;
    var deviceIdforSubmit = deviceId;
    var docId = getList[0].docId;
    var docName = getList[0].docName;
    var areaId = getList[0].areaId;
    // var docId = getList.isEmpty ? '' : getList[0].docId;
    // var docName = getList.isEmpty ? '' : getList[0].docName;
    // var areaId = getList.isEmpty ? '' : getList[0].areaId;
    var captimeforSubmit = dt.toString();
    var ffForSubmit = isSwitchedForFF == true ? "1" : "0";
    var fsForSubmit = isSwitchedForFS == true ? "1" : "0";
    var othersForSubmit = isSwitchedForOthers == true ? "1" : "0";
    print("doc ID $docId");
//     // print(a);
    docId == "0" ? docId = "$docId|$docName" : docId;
    var url =
        "$submit_rx_url?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&doctor_id=$docId&area_id=$areaId&latitude=$latitude&longitude=$longitude&image_name=$fileName&cap_time=$captimeforSubmit&item_list=$itemString&rx_type=$rxTypeValue&ff_presents=$ffForSubmit&associated_call_fs=$fsForSubmit&associated_call_others=$othersForSubmit";
// var url2= "$submit_rx_url?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&doctor_id=$docId|$docName&area_id=$areaId&latitude=$latitude&longitude=$longitude&image_name=$fileName&cap_time=$captimeforSubmit&item_list=$itemString&rx_type=$rxTypeValue&ff_presents=$ffForSubmit&associated_call_fs=$fsForSubmit&associated_call_others=$othersForSubmit&rx_type=$rxdropDownValue";
// // a311.yeapps.com/skf_rx_api/api_rx_submit/submit_data?cid=skf&user_id=it003&user_pass=1234&device_id=312131&doctor_id=1283866&area_id=demo&latitude=11.22&longitude=33.54&image_name=&cap_time=&item_list=2023|1||1892|1&rx_type=&ff_presents=&associated_call_fs=&associated_call_others=
    print("url1: $url");

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      var orderInfo = json.decode(response.body);
      print("order info from rx ${orderInfo}");
      String status = orderInfo['status'];
      String ret_str = orderInfo['ret_str'];

      if (status == "Success") {
        // print('widget.dcrKey: ${widget.dcrKey}');
        // print('objectimageId: $objectImageId');
        // print('widget.uniqueId: ${widget.uniqueId}');
        // print('widget.ck: ${widget.ck}');

        if (widget.ck == 'isCheck') {
          for (int i = 0; i <= finalMedicineList.length; i++) {
            deleteMedicinItem(widget.dcrKey);

            // finalItemDataList.clear();
            setState(() {});
          }

          deleteRxDoctor(widget.dcrKey);
        } else if (widget.ck == 'isOrphan') {
          for (int i = 0; i <= finalMedicineList.length; i++) {
            deleteMedicinItem(widget.uniqueId);

            // finalItemDataList.clear();
            setState(() {});
          }

          deleteRxDoctor(widget.uniqueId);
        } else {
          for (int i = 0; i <= finalMedicineList.length; i++) {
            deleteMedicinItem(objectImageId);

            // finalItemDataList.clear();
            setState(() {});
          }

          deleteRxDoctor(objectImageId);
        }
        // if (widget.ck == 'isCheck') {
        //   for (int i = 0; i <= finalMedicineList.length; i++) {
        //     deleteMedicinItem(widget.dcrKey);

        //     // finalItemDataList.clear();
        //     setState(() {});
        //   }

        //   deleteRxDoctor(widget.dcrKey);
        // }
        //  else if (widget.ck == "isOrphan") {
        //   for (int i = 0; i <= finalMedicineList.length; i++) {
        //     deleteMedicinItem(widget.dcrKey);

        //     // finalItemDataList.clear();
        //     setState(() {});
        //   }

        //   deleteRxDoctor(widget.dcrKey);
        // }

        setState(() {});

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                userName: userName,
                user_id: user_id,
              ),
            ),
            (Route<dynamic> route) => false);

        _submitToastforOrder(ret_str);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Rx submit Failed'), backgroundColor: Colors.red),
        );
      }
    } on Exception catch (e) {
      print(e);
      // throw Exception("Error on server");
    }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text(
    //         'Please Order something',
    //       ),
    //       backgroundColor: Color.fromARGB(255, 180, 59, 109)));
    // }
  }

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    print("file path${file.absolute.path}");
    print("out path${outPath}");
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, outPath,
        quality: 95, minHeight: 800, minWidth: 800);

    print(file.lengthSync());
    print(result!.lengthSync());
    print("result $result");

    return result;
  }

  // ..........Rx Image Submit................................

  Future<dynamic> _rxImageSubmit() async {
    // final compressfileForImage = await compressFile(imagePath!);

    var dt = DateFormat('HH:mm:ss').format(DateTime.now());
    calculateRxItemString();

    String time = dt.replaceAll(":", '');

    var postUri = Uri.parse(submit_photo_url!);

    http.MultipartRequest request = http.MultipartRequest("POST", postUri);
    if (widget.image1 != '') {
      final compressfileForImage = await compressFile(File(finalImage));

      setState(() {
        finalImage = compressfileForImage.toString();
      });

      int space = finalImage.indexOf(" ");
      String removeSpace = finalImage.substring(space + 1, finalImage.length);
      finalImage = removeSpace.replaceAll("'", '');

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'upload_file', finalImage.toString(),
        // filename: a,
        // filename: finalImage.split("-").last
      );

      request.files.add(multipartFile);
      http.StreamedResponse response = await request.send();
      var res = await http.Response.fromStream(response);
      final jsonData = json.decode(res.body);

      final status = jsonData["res_data"]["status"];
      final fileName = jsonData["res_data"]["ret_str"];

      // print(fileName);
      if (fileName != '' && status == "Success") {
        rxSubmit(fileName);
      } else {
        setState(() {
          _isLoading = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Rx Image submit Failed'),
              backgroundColor: Colors.red),
        );
      }
      // print(response.statusCode);
    } else {
      final compressfileForImage = await compressFile(imagePath!);

      String rxImage = '';

      setState(() {
        rxImage = compressfileForImage.toString();
      });

      int space = rxImage.indexOf(" ");
      String removeSpace = rxImage.substring(space + 1, rxImage.length);
      finalImage = removeSpace.replaceAll("'", '');

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'upload_file', finalImage,

        // filename: a,  "-").last
      );

      //request.fields["rxImage"] = finalImage;
      request.files.add(multipartFile);
      http.StreamedResponse response = await request.send();

      var res = await http.Response.fromStream(response);
      final jsonData = json.decode(res.body);
      // print(jsonData["res_data"]["ret_str"]);
      print("result 2nd condition rx image ${jsonData}");
      final status = jsonData["res_data"]["status"];
      final fileName = jsonData["res_data"]["ret_str"];

      // print(fileName);
      if (fileName != '' && status == "Success") {
        rxSubmit(fileName);
      } else {
        setState(() {
          _isLoading = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Rx Image submit Failed'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  // .......... Submit Toast messege..............
  void _submitToastforOrder(String ret_str) {
    Fluttertoast.showToast(
        msg: "Rx Submitted\n$ret_str",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  deleteRxDoctor(int id) {
    final box = Hive.box<RxDcrDataModel>("RxdDoctor");

    final Map<dynamic, RxDcrDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

// Save RX data to Hive......................................

  deleteMedicinItem(int id) {
    final box = Hive.box<MedicineListModel>("draftMdicinList");

    final Map<dynamic, MedicineListModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == id) {
        box.delete(key);
      }
    });
    // box.delete(desiredKey);
  }

  Future putAddedRxData() async {
    if (widget.ck == 'isCheck') {
      deleteMedicinItem(widget.dcrKey);
      // deleteRxDoctor(widget.uniqueId);

      //todo! abubakar

      final Doctorbox = Boxes.rxdDoctor();
      Doctorbox.toMap().forEach((key, value) {
        if (value.uiqueKey == widget.dcrKey) {
          value.docName = getList[0].docName;
          value.docId = getList[0].docId;
          value.address = getList[0].address;
          value.areaId = getList[0].areaId;
          value.areaName = getList[0].areaName;

          Doctorbox.put(key, value);
        }
      });

      //todo!  abubakar

      // getList[0].presImage = widget.image1;

      // for (var dcr in getList) {
      //   final box = Boxes.rxdDoctor();

      //   box.add(dcr);
      // }

      for (var d in finalMedicineList) {
        print("medicine foir orphan ${d.name}");
        d.uiqueKey = widget.dcrKey;

        final box = Boxes.getMedicine();

        box.add(d);
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(userName: userName, user_id: user_id)),
          (route) => false);
    } else if (widget.ck == "isOrphan") {
      if (_isCameraClick == true) {
        for (var dcr in getList) {
          print('uiniquIdD:${dcr.uiqueKey}');
          final box = Boxes.rxdDoctor();
          final medicineBox = Boxes.getMedicine();
          dcr.uiqueKey = objectImageId;
          box.toMap().forEach((key, value) {
            if (dcr.uiqueKey == value.uiqueKey) {
              value.docName = dcr.docName;
              value.docId = dcr.docId;
              value.areaName = dcr.areaName;
              value.areaId = dcr.areaId;
              value.address = dcr.address;
              box.put(key, value);
              if (finalMedicineList.isNotEmpty) {
                for (var element in finalMedicineList) {
                  element.uiqueKey = objectImageId;
                  medicineBox.add(element);
                }
              }
            }
          });
        }
      } else {
        for (var dcr in getList) {
          print('uiniquIdD:${dcr.uiqueKey}');
          final box = Boxes.rxdDoctor();
          final medicineBox = Boxes.getMedicine();
          // dcr.uiqueKey = objectImageId;
          box.toMap().forEach((key, value) {
            if (dcr.uiqueKey == value.uiqueKey) {
              value.docName = dcr.docName;
              value.docId = dcr.docId;
              value.areaName = dcr.areaName;
              value.areaId = dcr.areaId;
              value.address = dcr.address;
              box.put(key, value);
              if (finalMedicineList.isNotEmpty) {
                for (var element in finalMedicineList) {
                  element.uiqueKey = dcr.uiqueKey;
                  medicineBox.add(element);
                }
              }
            }
          });
        }
      }

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    userName: userName,
                    user_id: user_id,
                  )),
          (route) => false);
      // for (var dcr in getList) {
      //   print('uiniquIdD:${dcr.uiqueKey}');
      //   final box = Boxes.rxdDoctor();
      //   final medicineBox = Boxes.getMedicine();

      //   box.toMap().forEach((key, value) {
      //     if (dcr.uiqueKey == value.uiqueKey) {
      //       value.docName = dcr.docName;
      //       value.docId = dcr.docId;
      //       value.areaName = dcr.areaName;
      //       value.areaId = dcr.areaId;
      //       value.address = dcr.address;
      //       box.put(key, value);
      //       if (finalMedicineList.isNotEmpty) {
      //         for (var element in finalMedicineList) {
      //           element.uiqueKey = dcr.uiqueKey;
      //           medicineBox.add(element);
      //         }
      //       }
      //     }
      //   });
      // }

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MyHomePage(
      //               userName: userName,
      //               user_id: user_id,
      //             )),
      //     (route) => false);
    }
    //todo abuabakar
    else {
      for (var dcr in getList) {
        print('uiniquIdD:${dcr.uiqueKey}');
        final box = Boxes.rxdDoctor();
        final medicineBox = Boxes.getMedicine();
        dcr.uiqueKey = objectImageId;
        box.toMap().forEach((key, value) {
          if (dcr.uiqueKey == value.uiqueKey) {
            value.docName = dcr.docName;
            value.docId = dcr.docId;
            value.areaName = dcr.areaName;
            value.areaId = dcr.areaId;
            value.address = dcr.address;
            box.put(key, value);
            if (finalMedicineList.isNotEmpty) {
              for (var element in finalMedicineList) {
                element.uiqueKey = objectImageId;
                medicineBox.add(element);
              }
            }
          }
        });
      }

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    userName: userName,
                    user_id: user_id,
                  )),
          (route) => false);
    }
    //todo abubau

    //todo abuddd
    // else if (finalMedicineList.isEmpty) {
    //   for (int i = 0; i <= tempCount; i++) {
    //     deleteMedicinItem(widget.dcrKey);

    //     // finalItemDataList.clear();
    //     setState(() {});
    //   }

    //   setState(() {});

    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => MyHomePage(
    //                 userName: userName,
    //                 user_id: user_id,
    //               )),
    //       (route) => false);
    // } else {
    //   if (getList.isEmpty) {
    //     getList.add(
    //       RxDcrDataModel(
    //         uiqueKey: _counterforRx,
    //         docName: 'UnKnownDoctor',
    //         docId: '',
    //         areaId: '',
    //         areaName: 'areaName',
    //         address: 'address',
    //         presImage: imagePath.toString(),
    //       ),
    //     );
    //     for (var dcr in getList) {
    //       final box = Boxes.rxdDoctor();

    //       box.add(dcr);
    //     }
    //     for (var d in finalMedicineList) {
    //       final box = Boxes.getMedicine();

    //       box.add(d);
    //     }

    //     Navigator.pop(context);
    //   } else {
    //     getList[0].presImage = imagePath.toString();
    //     for (var dcr in getList) {
    //       final box = Boxes.rxdDoctor();

    //       box.add(dcr);
    //     }

    //     for (var d in finalMedicineList) {
    //       final box = Boxes.getMedicine();

    //       box.add(d);
    //     }

    //     Navigator.pop(context);
    //   }
    // }
    //todo aubbakar
  }

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('dcrListData');
  }

////////////////////////////docotr//////////////////////////
  // getRxDoctorData() async {
  //   // print('dra doc:${widget.uniqueId}');
  //   await openBox();
  //   var mymap = box!.toMap().values.toList();
  //   if (mymap.isNotEmpty) {
  //     doctorData = mymap;
  //     // print(doctorData);

  //     if (_activeCounter == true) {
  //       // ignore: use_build_context_synchronously
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => DoctorListScreen(
  //             counterCallback: (value) {
  //               counterForDoctor = value;

  //               setState(() {});
  //             },
  //             a: a,
  //             doctorData: doctorData,
  //             tempList: getList, //todo!
  //             counterForDoctorList: widget.uniqueId > 0
  //                 ? widget.uniqueId
  //                 : _isCameraClick == true
  //                     ? objectImageId
  //                     : _counterforRx,
  //             tempListFunc: (value) {
  //               getList = value;
  //               getList.forEach((element) {
  //                 docId = element.docId;
  //               });

  //               setState(() {});
  //             },
  //           ),
  //         ),
  //       );
  //     } else {
  //       // ignore: use_build_context_synchronously
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => DoctorListScreen(
  //             counterCallback: (value) {
  //               counterForDoctor = value;

  //               setState(() {});
  //             },
  //             a: a,
  //             doctorData: doctorData,
  //             tempList: getList,
  //             counterForDoctorList:
  //                 widget.uniqueId > 0 ? widget.uniqueId : counterForDoctor,
  //             tempListFunc: (value) {
  //               getList = value;
  //               getList.forEach((element) {
  //                 docId = element.docId;
  //               });

  //               setState(() {});
  //             },
  //           ),
  //         ),
  //       );
  //     }
  //     // print(
  //     //     'drcounter:${widget.uniqueId > 0 ? widget.uniqueId : _activeCounter == true ? _counterforRx : counterForDoctor}');
  //   } else {
  //     doctorData.add('Empty');
  //   }
  // }

///////////////////////////////medicine///////////////////////////////
  Future openMedicineBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('MedicineList');
  }

  getMedicine() async {
    await openMedicineBox();
    var mymap = box!.toMap().values.toList();

    if (mymap.isNotEmpty) {
      medicineData = mymap;
      // print('test1:$counterForDoctor');
      // ignore: use_build_context_synchronously

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MedicinListScreen(
                  counter: (getList.isNotEmpty && getList[0].docId != '')
                      ? counterForDoctor
                      : _isCameraClick == true
                          ? objectImageId
                          : widget.uniqueId > 0
                              ? widget.uniqueId
                              : _counterforRx,
                  medicineData: medicineData,
                  tempList: finalMedicineList,
                  img: imagePath,
                  img1: finalImage,
                  tempListFunc: (value) {
                    finalMedicineList = value;
                    setState(() {});
                  },
                )),
      );
    }
    // if (mymap.isNotEmpty) {
    //   medicineData = mymap;

    //   // print('test1:$counterForDoctor');
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (_) => MedicinListScreen(
    //         counter: (getList.isNotEmpty && getList[0].docId != '')
    //             ? counterForDoctor
    //             : _counterforRx,
    //         medicineData: medicineData,
    //         tempList: finalMedicineList,
    //         tempListFunc: (value) {
    //           finalMedicineList = value;
    //           setState(() {});
    //         },
    //       ),
    //     ),
    //   );
    // }

    else {
      medicineData.add('Empty');
    }
  }

  deleteMedicineItem(int id, int index) {
    final box = Hive.box<MedicineListModel>("draftMdicinList");
    final Map<dynamic, MedicineListModel> medicineMap = box.toMap();
    dynamic newKey;
    medicineMap.forEach((key, value) {
      if (value.uiqueKey == id) {
        newKey = key;
      }
    });
    box.delete(newKey);
    finalMedicineList.removeAt(index);
  }

  // void _submitToastforSelectDoctor() {
  //   Fluttertoast.showToast(
  //       msg: 'Please Select Doctor First',
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.CENTER,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Confirm'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Do you want to delete this medicine?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                if (widget.ck != '') {
                  final medicineUniqueKey = finalMedicineList[index].uiqueKey;

                  deleteMedicineItem(medicineUniqueKey, index);
                  setState(() {});
                } else {
                  finalMedicineList.removeAt(index);
                  setState(() {});
                }
                // print('Confirmed');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //todo Abub

  int uniqueIdForImage() {
    int id = 0;
    id = int.parse(
        DateFormat('HH:mm:ssss').format(DateTime.now()).replaceAll(":", ''));
    setState(() {
      objectImageId = id;
    });
    return id;
  }

  //todo abu
  Future<void> _cameraFuntionality() async {
//todo
    setState(() {
      print('changebefore: $_isCameraClick');
      _isCameraClick = true;
      print('changeafter: $_isCameraClick');
    });
//todo
    file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      //preferredCameraDevice: CameraDevice.rear,

      // maxHeight: 800
    );
    if (file != null) {
      setState(() {
        file;
        imagePath = File(file!.path);
        widget.image1 = '';
        if (imagePath != null && widget.ck == "") {
          if (getList.isEmpty) {
            //todo Abu
            getList.add(RxDcrDataModel(
              uiqueKey:
                  widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
              docName:
                  tempdocName == "" ? objectImageId.toString() : tempdocName,
              docId: docId == '' ? "" : docId,
              areaId: areaid == "" ? "" : areaid,
              areaName: areaName == '' ? "areaName" : areaName,
              address: address == '' ? "address" : address,
              presImage: imagePath.toString(),
            ));
            print("Image Get for File:$imagePath");
            for (var dcr in getList) {
              final box = Boxes.rxdDoctor();

              box.add(dcr);
            }
            for (var d in finalMedicineList) {
              final box = Boxes.getMedicine();

              box.add(d);
            }
          } else {
            getList.clear();
            getList.add(
              RxDcrDataModel(
                uiqueKey:
                    widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
                docName:
                    tempdocName == "" ? objectImageId.toString() : tempdocName,
                docId: docId == "" ? '' : docId,
                areaId: areaid == '' ? "" : areaid,
                areaName: areaName == '' ? "areaName" : areaName,
                address: address == '' ? "address" : address,
                presImage: imagePath.toString(),
              ),
            );

            for (var dcr in getList) {
              final box = Boxes.rxdDoctor();

              box.add(dcr);
            }
            for (var d in finalMedicineList) {
              final box = Boxes.getMedicine();

              box.add(d);
            }
          }
        } else if (imagePath != null && widget.ck != '') {
          final Doctorbox = Boxes.rxdDoctor();
          Doctorbox.toMap().forEach((key, value) {
            if (value.uiqueKey == widget.dcrKey) {
              value.presImage = imagePath.toString();
              Doctorbox.put(key, value);
            }
          });
          // widget.image1 = imagePath.toString();
        }
        //todo abu
      });
    }
  }

  Future<void> _galleryFunctionality() async {
    file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      //preferredCameraDevice: CameraDevice.rear,
      maxHeight: 800,
      maxWidth: 700,
    );
    if (file != null) {
      setState(() {
        file;
        imagePath = File(file!.path);
        widget.image1 = '';
        if (imagePath != null && widget.ck == "") {
          if (getList.isNotEmpty) {
            //todo Abu
            getList.add(RxDcrDataModel(
              uiqueKey:
                  widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
              docName: widget.docName,
              docId: '',
              areaId: '',
              areaName: "areaName",
              address: "address",
              presImage: imagePath.toString(),
            ));
            for (var dcr in getList) {
              final box = Boxes.rxdDoctor();

              box.add(dcr);
            }
            for (var d in finalMedicineList) {
              final box = Boxes.getMedicine();

              box.add(d);
            }
          } else {
            getList.clear();
            getList.add(
              RxDcrDataModel(
                uiqueKey:
                    widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
                docName: objectImageId.toString(),
                docId: '',
                areaId: '',
                areaName: 'areaName',
                address: 'address',
                presImage: imagePath.toString(),
              ),
            );

            for (var dcr in getList) {
              final box = Boxes.rxdDoctor();

              box.add(dcr);
            }
            for (var d in finalMedicineList) {
              final box = Boxes.getMedicine();

              box.add(d);
            }
          }
        } else if (imagePath != null && widget.ck != '') {
          final Doctorbox = Boxes.rxdDoctor();
          Doctorbox.toMap().forEach((key, value) {
            if (value.uiqueKey == widget.dcrKey) {
              value.presImage = imagePath.toString();
              Doctorbox.put(key, value);
            }
          });
          // widget.image1 = imagePath.toString();
        }
      });
    }
  }

  void _submitToastforphoto() {
    Fluttertoast.showToast(
        msg: 'Please Take Image  ',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _submitToastforMedicine() {
    Fluttertoast.showToast(
        msg: 'Please Take Image First and Select Medicine ',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class ZoomForRxImage extends StatelessWidget {
  File? img;
  ZoomForRxImage(this.img);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imageHero',
              child: PhotoView(
                imageProvider: FileImage(img!),
                enableRotation: true,
                filterQuality: FilterQuality.high,
                enablePanAlways: false,
                maxScale: 4.0,
              )),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class ZoomForRxDraftImage extends StatelessWidget {
  String? draftFinalImage;
  ZoomForRxDraftImage(this.draftFinalImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageForDraft',
            child: PhotoView(
              filterQuality: FilterQuality.high,
              imageProvider: FileImage(File(draftFinalImage!)),
              enableRotation: true,
              enablePanAlways: false,
              maxScale: 4.0,
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context);
        },
      ),
    );
  }
}
