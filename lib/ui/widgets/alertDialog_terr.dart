// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharma_rx/models/hive_data_model.dart';
import 'package:pharma_rx/services/apiCall.dart';
import 'package:pharma_rx/ui/pages/Rx/doctor_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

List regionList = [];
List areaListoregion = [];
List areaNameList = [];
List territoryNameList = [];

var body;
var sec;
List result = [];
List territoryList = [];
List<String> result_two = [];
var doctorName;

List<RxDcrDataModel> doctorFinalList = [];
List<RxDcrDataModel> doctroList = [];
List regionName = [];

class TerritoryList extends StatefulWidget {
  String region = "";

  String area = " ";

  String territory = "";
  TerritoryList({
    Key? key,
    required this.region,
    required this.area,
    required this.territory,
  }) : super(key: key);

  @override
  State<TerritoryList> createState() => _TerritoryListState();
}

class _TerritoryListState extends State<TerritoryList> {
  String? value;
  String? newValue;
  String regionID = "";
  String areaID = " ";
  bool isChanged = false;
  Box? box;
  var terror;
  var terrorID;
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

      areaNameList = areaListoregion.map((e) => e["area_name"]).toList();
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

  @override
  Widget build(BuildContext context) {
    print(area);
    print(region);
    print(territory);
    return AlertDialog(
      content: SizedBox(
        height: 350,
        child: StatefulBuilder(builder: (context, setState2) {
          return Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Region"),
              ),
              const SizedBox(
                height: 10,
              ),
              regionName.isEmpty
                  ? CircularProgressIndicator()
                  : Container(
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
                                      this.value = newValue as String?;
                                    });
                                  },
                                  onChanged: (newValue) async {
                                    setState2(() {
                                      this.value = newValue as String?;

                                      region = newValue!;
                                      regionList.forEach((element) {
                                        if (element["region_name"] == region) {
                                          regionID = element["region_id"];
                                          print(regionID);
                                        }
                                      });

                                      doctorarea(newValue);
                                    });

                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString("region", region);
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
                                    print("area on saved ${this.value}");
                                  });
                                },
                                onChanged: (String? newValue) async {
                                  setState2(
                                    () {
                                      this.value = newValue as String?;

                                      area = newValue!;
                                      areaListoregion.forEach((element) {
                                        if (element["area_name"] == area) {
                                          areaID = element["area_id"];
                                          print(areaID);
                                        }
                                      });
                                      doctorTerrority(newValue);
                                      // });
                                    },
                                  );
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString("area", area);
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
                                territorySecondList.forEach((element) {
                                  terror = element["territory_name"];
                                });
                                print("teerr name ${terror}");

                                territory = terror;

                                print("onChanged ${territory}");
                              });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString("territory", territory);
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
              ElevatedButton(
                  onPressed: () async {
                    if (areaID != " ") {
                      box = Hive.box("doctorList");
                      box?.clear();
                      // terrorID ?? (newterrorID = terrorID);
                      newterrorID = terrorID;
                      print(terrorID);
                      result = await ApiCall()
                          .doctorArea(regionID, areaID, terrorID);
                      // setState(() {});
                      doctroList.clear();

                      for (var disco in result) {
                        box?.add(disco);
                      }

                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please Select Area ',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: Text("Get Doctor List"))
            ],
          );
        }),
      ),
    );
  }
}
