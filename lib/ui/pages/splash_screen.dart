// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharma_rx/models/boxes.dart';
import 'package:pharma_rx/models/hive_data_model.dart';
import 'package:pharma_rx/ui/pages/homePage.dart';
import 'package:pharma_rx/ui/pages/loginPage.dart';
import 'package:pharma_rx/ui/pages/sync_data_tab_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String cid = '';
  String userId = '';
  String userPassword = '';
  String? areaPage;
  String? user_id;
  String? userName;
  List itemToken = [];
  List dcrDataList = [];
  List dcrtToken = [];
  List gifttToken = [];
  List clientToken = [];
  Box? box;

  double? latitude;
  double? longitude;

  @override
  void initState() {
    getLatLong();

    Hive.openBox('MedicineList').then(
      (value) {
        // var mymap = value.toMap().values.toList();
        clientToken = value.toMap().values.toList();

        setState(() {});

        SharedPreferences.getInstance().then(
          (prefs) {
            cid = prefs.getString("CID") ?? '';
            userId = prefs.getString("USER_ID") ?? '';
            userPassword = prefs.getString("PASSWORD") ?? '';
            areaPage = prefs.getString("areaPage");
            userName = prefs.getString("userName");
            user_id = prefs.getString("user_id");

            // print(areaPage);

            if (cid != '' && userId != '' && userPassword != '') {
              if (clientToken.isNotEmpty) {
                Timer(
                  const Duration(seconds: 2),
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyHomePage(
                        userName: userName!,
                        user_id: userId,
                      ),
                    ),
                  ),
                );
              } else {
                Timer(
                    const Duration(seconds: 2),
                    () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SyncDataTabPage(),
                          ),
                        ));
              }
            } else {
              Timer(
                const Duration(seconds: 2),
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                ),
              );
            }
          },
        );
      },
    );

    super.initState();
  }

  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      // print("value $value");
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;
      });
      SharedPreferences.getInstance().then((prefs) {
        prefs.setDouble("latitude", latitude!);
        prefs.setDouble("longitude", longitude!);
      });
    }).catchError((error) {
      // print("Error $error");
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/mRep7_wLogo.png",
                color: Colors.white,
              ),
              const SizedBox(
                height: 20,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
