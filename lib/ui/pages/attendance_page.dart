import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:pharma_rx/ui/pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  TextEditingController mtrReading = TextEditingController();
  late AnimationController controller;
  var dt = DateFormat('HH:mm a').format(DateTime.now());

  String? userPass;
  String? cid;
  String? userId;
  double? lat;
  String? submit_atten_url;
  String userName = '';
  String user_id = '';
  String? deviceId = '';
  var status;
  double? long;

  String address = "";

  @override
  void initState() {
    getLatLong();
    SharedPreferences.getInstance().then((prefs) {
      print(prefs.getString("submit_atten_url"));

      if ((prefs.getString("CID") == null) ||
          (prefs.getString("USER_ID") == null) ||
          prefs.getString("PASSWORD") == null) {
        return;
      } else {
        cid = prefs.getString("CID");
        userId = prefs.getString("USER_ID");
        userPass = prefs.getString("PASSWORD");
        submit_atten_url = prefs.getString("submit_atten_url");
        userName = prefs.getString("userName")!;
        user_id = prefs.getString("user_id")!;
        deviceId = prefs.getString("deviceId");

        print("ssssssssssssssssssss$submit_atten_url");
      }
    });

    super.initState();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });
      getAddress(value.latitude, value.longitude);
    }).catchError((error) {});
  }

  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    print(placemarks);
    setState(() {
      address = placemarks[0].street! + " " + placemarks[0].country!;
    });
    for (int i = 0; i < placemarks.length; i++) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        title: const Text("Attendance"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: (lat == null && long == null)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DataTable(
                      dataRowHeight: 70,
                      columns: const [
                        DataColumn(label: Text("")),
                        DataColumn(label: Text(""))
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                "Latitude",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                lat.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                "Longitude",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                "$long",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                "Address",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                address,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                "Time",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                dt,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // DataRow(
                        //   color: MaterialStateProperty.all(
                        //       const Color.fromARGB(255, 230, 179, 192)),
                        //   cells: [
                        //     const DataCell(
                        //       Text(
                        //         "Meter Reading",
                        //         style: TextStyle(
                        //             color: Colors.black,
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.w400),
                        //       ),
                        //     ),
                        //     DataCell(
                        //       TextField(
                        //         controller: mtrReading,
                        //         style: const TextStyle(
                        //             color: Colors.black,
                        //             fontWeight: FontWeight.w500),
                        //         inputFormatters: [
                        //           FilteringTextInputFormatter.digitsOnly
                        //         ],
                        //         keyboardType: TextInputType.number,
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              primary: Colors.teal.withOpacity(0.5),
                              onPrimary: Colors.white,
                            ),
                            onPressed: () async {
                              await attendanceAPI(
                                context,
                                "START",
                              );

                              if (status == 'Failed') {
                                Fluttertoast.showToast(
                                    msg: 'Attendance Failed',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.SNACKBAR,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              // print('object');
                            },
                            child: const Text(
                              "Day Start",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                primary: Colors.blueGrey,
                                onPrimary: Colors.white),
                            onPressed: () async {
                              await attendanceAPI(context, "END");

                              if (status == 'Failed') {
                                Fluttertoast.showToast(
                                    msg: 'Attendance Failed',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.SNACKBAR,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            child: const Text(
                              "Day End",
                              style: TextStyle(fontSize: 20),
                            ),
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

  Future attendanceAPI(BuildContext context, String submitType) async {
    print(
        "AAAAAAAAAAAAAAAAAAAA:::::${submit_atten_url}?cid=$cid&user_id=$userId&user_pass=$userPass&device_id=$deviceId&latitude=${lat.toString()}&longitude=${long.toString()}&address=${address.toString()}&submit_type=$submitType&meter_reading=${mtrReading.text}");
    final response = await http.get(
      Uri.parse(
          "${submit_atten_url}?cid=$cid&user_id=$userId&user_pass=$userPass&device_id=$deviceId&latitude=${lat.toString()}&longitude=${long.toString()}&address=${address.toString()}&submit_type=$submitType&meter_reading=${mtrReading.text}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var data = json.decode(response.body);
    print("data ${data["status"]}");
    if (data["status"] == "Success") {
      var returnString = data["ret_str"];
      var startTime = data["start_time"];
      var endTime = data["end_time"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('startTime', startTime);
      await prefs.setString('endTime', endTime);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    userName: userName,
                    user_id: user_id,
                  )));
    } else {
      return "Failed";
    }
  }
}
