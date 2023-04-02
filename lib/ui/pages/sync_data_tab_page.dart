// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pharma_rx/main.dart';
import 'package:pharma_rx/services/apiCall.dart';
import 'package:pharma_rx/services/data_sync/data_sync_and_saveTo_hive.dart';
import 'package:pharma_rx/ui/pages/homePage.dart';
import 'package:pharma_rx/ui/widgets/sync_widget_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

List regionNamefromSync = [];
var terorData;

class SyncDataTabPage extends StatefulWidget {
  const SyncDataTabPage({Key? key}) : super(key: key);

  @override
  State<SyncDataTabPage> createState() => _SyncDataTabPageState();
}

class _SyncDataTabPageState extends State<SyncDataTabPage> {
  var newMed = {};
  Box? box;
  String medicine_rx_url = '';
  String cid = '';
  String userId = '';
  String userPassword = '';
  String userName = '';
  String user_id = '';
  String status = 'failed';
  String startTime = '';
  String endTime = '';
  // static bool sync = true;
  List data = [];
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  //  Timer t;
  // List<SyncCustomerData>? data;

  // void   sync(){
  //     Timer.periodic(, (timer) {
  //     print("sync hbena");
  //     sync = false;
  //   });
  // }
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        medicine_rx_url = prefs.getString("medicine_rx_url") ?? " ";
        cid = prefs.getString("CID") ?? "";
        userId = prefs.getString("USER_ID") ?? "";
        userPassword = prefs.getString("PASSWORD") ?? "";
        userName = prefs.getString("userName") ?? "";
        user_id = prefs.getString("user_id") ?? "";
        startTime = prefs.getString("startTime") ?? '';
        endTime = prefs.getString("endTime") ?? '';
      });
    });
    print(sync);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffD8E5F1),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        title: const Text('Sync Data'),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        // title: const Text(
        //   'Sync Data',
        //   style: TextStyle(color: Colors.white),
        // ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       child: SyncWidgetbutton(
              //         onClick: () async {
              //           bool result =
              //               await InternetConnectionChecker().hasConnection;
              //           if (result == true) {
              //             DataSyncAndSaveToHive().getMedicineData(
              //                 sync_url, cid, userId, userPassword, context);

              //             DataSyncAndSaveToHive().getDcrData(
              //                 sync_url, cid, userId, userPassword, context);
              //             // print('YAY! Free cute dog pics!');
              //           } else {
              //             _submitToastforOrder3();

              //             // print('No internet :( Reason:');
              //             // print(InternetConnectionChecker().lastTryResults);
              //           }
              //         },
              //         color: Colors.teal.withOpacity(.5),
              //         title: 'Sync ALL',
              //         sizeWidth: screenWidth,
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                children: [
                  // Expanded(
                  //   child: SyncWidgetbutton(
                  //     onClick: () async {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (_) => const AreaPage()));
                  //       bool result =
                  //           await InternetConnectionChecker().hasConnection;
                  //       if (result == true) {
                  //         DataSyncAndSaveToHive().getDcrData(
                  //             sync_url, cid, userId, userPassword, context);
                  //       } else {
                  //         _submitToastforOrder3();

                  //         // print('No internet :( Reason:');
                  //         // print(InternetConnectionChecker().lastTryResults);
                  //       }
                  //     },
                  //     color: Colors.white,
                  //     title: 'DOCTOR',
                  //     sizeWidth: screenWidth,
                  //   ),
                  // ),
                  Expanded(
                    flex: 3,
                    child: SyncWidgetbutton(
                      onClick: () async {
                        if (sync == true) {
                          String msg = ' Synchronizing Medicine....';
                          buildShowDialog(context, msg);
                          // Hive.openBox('MedicineList').then(
                          //   (value) async {
                          //     // var mymap = value.toMap().values.toList();
                          //     List dcrDataList = value.toMap().values.toList();

                          bool result =
                              await InternetConnectionChecker().hasConnection;
                          if (result == true) {
                            newMed = await DataSyncAndSaveToHive()
                                .getMedicineData(medicine_rx_url, cid, context);

                            if (newMed["status"] == "Success") {
                              print(
                                  "medicine list ${newMed["rxItemList"].length}");
                              sync = false;
                              Navigator.pop(context);
                            } else {}
                          } else {
                            _submitToastforOrder3();

                            // print('No internet :( Reason:');
                            // print(InternetConnectionChecker().lastTryResults);
                          }
                          // Timer.periodic(Duration(seconds: 30), (timer) async {

                          // });
                        } // }
                        else {
                          // Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg:
                                  'Data synced recently \n please try after 30 mintutes',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.SNACKBAR,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        // },
                        // );

                        Timer(Duration(minutes: 15), () async {
                          sync = true;
                          print("$sync print hbe");
                        });
                      },
                      color: const Color.fromARGB(148, 98, 224, 140),
                      title: 'SYNC MEDICINE',
                      sizeWidth: screenWidth,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      height: screenHeight / 9,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 4,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 68, 169, 216),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.home,
                          size: 38,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MyHomePage(
                                userName: userName,
                                user_id: user_id,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
