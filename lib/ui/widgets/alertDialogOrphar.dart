// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:pharma_rx/models/boxes.dart';
import 'package:pharma_rx/models/hive_data_model.dart';
import 'package:pharma_rx/services/apiCall.dart';
import 'package:pharma_rx/ui/pages/Rx/rx_screen.dart';
import 'package:pharma_rx/ui/pages/homePage.dart';

import '../pages/Rx/doctor_list.dart';

class OrphanDoctor extends StatefulWidget {
  int counterForDoctorList;
  String orphanImg;
  List<MedicineListModel> med;
  OrphanDoctor({
    Key? key,
    required this.counterForDoctorList,
    required this.orphanImg,
    required this.med,
  }) : super(key: key);

  @override
  State<OrphanDoctor> createState() => _OrphanDoctorState();
}

class _OrphanDoctorState extends State<OrphanDoctor> {
  TextEditingController doctorController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  List doctorList = [];
  List<RxDcrDataModel> getList = [];

  String? value;
  String? newValue;
  bool isChanged = false;
  Box? box;
  var terror;
  var terrorID;
  int dcrKey = 0;

  @override
  void initState() {
    regionListFunc();
    super.initState();
  }

  regionListFunc() async {
    var body = await ApiCall().getRegionList();
    // print(body);
    setState(() {
      isChanged = true;
    });
    regionList = await body["region_list"];
    regionName = regionList.map((e) => e["region_name"]).toList();
  }

  doctorarea(String area) {
    print(area);

    List x =
        regionList.where((element) => element["region_name"] == area).toList();

    x.forEach((element) {
      Map regionmappedList = element;
      areaListoregion = regionmappedList["area_list"];
      // print(areaListoregion);
      areaNameList = areaListoregion.map((e) => e["area_name"]).toList();

      // String areaNameoutOfareaList = areaListoregion["area_name"];
    });
  }

  doctorTerrority(String territory) {
    print(territory);
    List y = areaListoregion
        .where((element) => element["area_name"] == territory)
        .toList();

    y.forEach((element) {
      Map territoryMap = element;
      territoryList = territoryMap["territory_list"];

      // territoryNameList =
      //     territoryList.map((e) => e["territory_name"]).toList();
      print(territoryList);
    });

    // areaListoregion.forEach((element) {
    //   Map areaList = element;
    //   List territory = areaList["territory_list"];
    //   // String area_name = areaList["area_name"];

    //   // print(area_name);
    // });
  }

  timeStamp() {
    String id;
    DateTime time = DateTime.now();
    id = time.millisecondsSinceEpoch.toString();
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 550,
        child: StatefulBuilder(builder: (context, setState2) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Region"),
                ),
                const SizedBox(
                  height: 10,
                ),
                regionName.isEmpty
                    ? const CircularProgressIndicator()
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: Colors.black54, width: 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    // value: valu,
                                    iconSize: 30,
                                    hint: const Text("Select your Region"),
                                    items: regionName.map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item.toString(),
                                        child: Text(
                                          item,
                                        ),
                                      );
                                    }).toList(),
                                    onSaved: (newValue) {
                                      setState2(() {
                                        value = newValue as String?;
                                      });
                                    },
                                    onChanged: (newValue) async {
                                      setState2(() {
                                        value = newValue as String?;
                                        orpharegion = newValue!;
                                        doctorarea(newValue);
                                      });

                                      // SharedPreferences prefs =
                                      //     await SharedPreferences.getInstance();
                                      // prefs.setString("region",  orpharegion);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Area"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black54, width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatefulBuilder(builder: (context, setState3) {
                        return Expanded(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButtonFormField(
                                  isExpanded: true,
                                  // value: valu,
                                  iconSize: 30,
                                  hint: const Text("Select your area"),
                                  items: areaNameList.map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item.toString(),
                                      child: Text(
                                        item,
                                      ),
                                    );
                                  }).toList(),
                                  onSaved: (newValue) {
                                    setState2(() {
                                      this.value = newValue as String?;
                                    });
                                  },
                                  onChanged: (String? newValue) async {
                                    setState2(
                                      () {
                                        value = newValue;

                                        orpharea = newValue!;
                                        doctorTerrority(newValue);
                                        // });
                                      },
                                    );
                                    // SharedPreferences prefs =
                                    //     await SharedPreferences.getInstance();
                                    // prefs.setString("area",  orpharea );
                                  }),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Territory"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black54, width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              iconSize: 30,
                              hint: const Text("Slect your territory"),
                              items: territoryList.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item["territory_id"].toString(),
                                  child: Text(
                                    item["territory_name"],
                                  ),
                                );
                              }).toList(),
                              onSaved: (value) {
                                print(value);
                                // setState2(() {
                                //   this.value = newValue as String;
                                //   // terror = newValue;
                                //   // print("onSaved e value${terror}");
                                // });
                              },
                              onChanged: (newValue) async {
                                setState2(() {
                                  this.value = newValue as String?;
                                  terrorID = this.value!;

                                  List territorySecondList = territoryList
                                      .where((element) =>
                                          element["territory_id"] == terrorID)
                                      .toList();
                                  print(territorySecondList);
                                  for (var element in territorySecondList) {
                                    terror = element["territory_name"];
                                  }

                                  orphaterritory = terror;

                                  // print("onChanged $orphaterritory");
                                });
                                // SharedPreferences prefs =
                                //     await SharedPreferences.getInstance();
                                // prefs.setString("territory", orphaterritory);
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Doctor Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: doctorController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.medication),
                    hintText: "* Doctor Name",
                    filled: true,
                    fillColor: const Color(0xFFE2EFDA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Doctor Address"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: adressController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.medication),
                    hintText: "* Doctor Address",
                    filled: true,
                    fillColor: const Color(0xFFE2EFDA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (doctorController.text.isNotEmpty &&
                          terrorID != null) {
                        setState(() {
                          // var dcrKey;
                          // final rxOrphan = Boxes.rxdDoctor();
                          // var data = RxDcrDataModel(
                          //     uiqueKey: widget.counterForDoctorList,
                          //     docName: doctorController.text.toString(),
                          //     docId: "0",
                          //     areaId: terrorID,
                          //     areaName: orphaterritory,
                          //     address: adressController.text.toString(),
                          //     presImage: widget.orphanImg);
                          // rxOrphan.add(data);
                          // dcrKey = data.uiqueKey;
                          // print("orphan test dcr key${dcrKey}");
                          newterrorIDorpha = terrorID;

                          tempdocName = doctorController.text.toString();
                          docId = "0";
                          areaName = orphaterritory;
                          areaid = newterrorIDorpha;
                          address = adressController.text.toString();
                        });

                        // widget.getList!(doctorFinalList);
                        print(
                            "gggggggggggggggggggggggggggggggg${widget.counterForDoctorList}");
                        print("gggggggggggggggggggggggggggggggg${dcrKey}");

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RxScreen(
                                      address: adressController.text.toString(),
                                      areaName: orphaterritory,
                                      ck: 'isOrphan',
                                      docId: '0',
                                      docName: doctorController.text.toString(),
                                      dcrKey: dcrKey,
                                      draftRxMedicinItem: widget.med,
                                      uniqueId: widget.counterForDoctorList,
                                      image1: widget.orphanImg,
                                      areaId: terrorID,
                                    )),
                            (route) => false);

                        // widget.getList!(widget.tempDoctorList);
                        // var nav = Navigator.of(context);
                        // nav.pop();
                        // nav.pop();
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please Enter Doctor Name & Territory.',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: const Text("Add New Doctor"))
              ],
            ),
          );
        }),
      ),
    );
  }
}
