import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharma_rx/models/hive_data_model.dart';
import 'package:pharma_rx/models/region_area_terr.dart';
import 'package:pharma_rx/services/apiCall.dart';
import 'package:pharma_rx/ui/pages/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// List region = [];
// List region_List = [];
// List areafinalList = [];
// List areaListoregion = [];
// List territoryfinalList = [""];
// List<RegionList> regionListFromJson(String str) =>
// //     List<RegionList>.from(region_List);
// var terror_name = "";
// var areaName = "";

class DoctorListScreen extends StatefulWidget {
  String a;
  List doctorData;
  List<RxDcrDataModel> tempList;
  int counterForDoctorList;
  Function(List<RxDcrDataModel>) tempListFunc;
  Function counterCallback;

  DoctorListScreen(
      {Key? key,
      required this.a,
      required this.doctorData,
      required this.tempList,
      required this.counterForDoctorList,
      required this.tempListFunc,
      required this.counterCallback})
      : super(key: key);

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  Box? box;
  List syncItemList = [];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();
  List foundUsers = [];
  bool ok = true;
  List<String> item = ["A", "b", "c"];

  @override
  void initState() {
    foundUsers = widget.doctorData;

    print(region_List.length);
    // region = region_List.map((e) => e["region_name"]).toList();
    SharedPreferences.getInstance().then((prefs) {
      if (widget.counterForDoctorList == 0) {
        int? a = prefs.getInt('DCLCounter') ?? 0;

        setState(() {
          widget.counterForDoctorList = a;
          widget.counterCallback(_doctorCOunter());
          // print('hey ${widget.counterForDoctorList}');
        });
      }
    });

    // print(foundUsers);
    super.initState();
  }

  // doctorarea(String area) {
  //   print(area);
  //   setState(() {
  //     List x = region_List
  //         .where((element) => element["region_name"] == area)
  //         .toList();
  //     // print(x);
  //     x.forEach((element) {
  //       Map regionmappedList = element;
  //       areaListoregion = regionmappedList["area_list"];
  //       // print(areaListoregion);
  //       areafinalList = areaListoregion.map((e) => e["area_name"]).toList();
  //       print(areafinalList);

  //       // String areaNameoutOfareaList = areaListoregion["area_name"];
  //     });
  //   });
  // }

  // doctorTerrority(String territory) {
  //   setState(() {
  //     print(territory);
  //     List y = areaListoregion
  //         .where((element) => element["area_name"] == territory)
  //         .toList();
  //     print(y);
  //     y.forEach((element) {
  //       Map territoryMap = element;
  //       List territoryList = territoryMap["territory_list"];
  //       print(territoryList);
  //       territoryfinalList =
  //           territoryList.map((e) => e["territory_name"]).toList();
  //       print(territoryfinalList);
  //     });
  //   });

  //   // areaListoregion.forEach((element) {
  //   //   Map areaList = element;
  //   //   List territory = areaList["territory_list"];
  //   //   // String area_name = areaList["area_name"];

  //   //   // print(area_name);
  //   // });
  // }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void runFilter(String enteredKeyword) {
    foundUsers = widget.doctorData;
    List results = [];

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = foundUsers;
      // print(results);
    } else {
      var starts = foundUsers
          .where((s) => s['doc_name']
              .toLowerCase()
              .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = foundUsers
          .where((s) =>
              s['doc_name']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) &&
              !s['doc_name']
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList()
        ..sort((a, b) =>
            a['doc_name'].toLowerCase().compareTo(b['doc_name'].toLowerCase()));

      results = [...starts, ...contains];
    }

    // Refresh the UI
    setState(() {
      foundUsers = results;
    });
  }

  int _doctorCOunter() {
    setState(() {
      widget.counterForDoctorList++;
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('DCLCounter', widget.counterForDoctorList);
    });
    return widget.counterForDoctorList;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    // String? regiondropDownValue = region.first;
    // String? areadropDownValue = areafinalList[0];
    // String? terrorDropDownValue = territoryfinalList[0];
    // String? dropDownValue = item.first;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Rx DoctorList Page'),
          centerTitle: true,
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         showDialog(
          //             context: context,
          //             builder: (BuildContext builder) {
          //               return AlertDialog(
          //                 // backgroundColor: Color.fromARGB(166, 205, 248, 227),
          //                 content: SizedBox(
          //                   height: screenHeight / 2.5,
          //                   width: screenWidth,
          //                   child: StatefulBuilder(
          //                       builder: (BuildContext context, setState2) {
          //                     return Column(
          //                       children: [
          //                         const Align(
          //                             alignment: Alignment.centerLeft,
          //                             child: Text("Region")),
          //                         SizedBox(
          //                           height: 50,
          //                           width: double.infinity,
          //                           child: Card(
          //                             elevation: 8,
          //                             child: StatefulBuilder(builder:
          //                                 (BuildContext context, setState3) {
          //                               return DropdownButton(
          //                                 value: region_List.isEmpty
          //                                     ? "OK"
          //                                     : regiondropDownValue,

          //                                 icon: const Icon(
          //                                   Icons.keyboard_arrow_down,
          //                                   color: Colors.black,
          //                                 ),

          //                                 // Array list of items
          //                                 items: region_List.isEmpty
          //                                     ? item.map((items) {
          //                                         // rowdyrathor();
          //                                         return DropdownMenuItem(
          //                                           value: items,
          //                                           child: Text(
          //                                             items,
          //                                             style: const TextStyle(
          //                                               color: Colors.black,
          //                                               // fontSize: 16,
          //                                             ),
          //                                           ),
          //                                         );
          //                                       }).toList()
          //                                     : region_List
          //                                         .map((e) => e["region_name"])
          //                                         .toList()
          //                                         .map((items) {
          //                                         // rowdyrathor();
          //                                         return DropdownMenuItem(
          //                                           value: items,
          //                                           child: Text(
          //                                             items,
          //                                             style: const TextStyle(
          //                                               color: Colors.black,
          //                                               // fontSize: 16,
          //                                             ),
          //                                           ),
          //                                         );
          //                                       }).toList(),

          //                                 onChanged: (newValue) {
          //                                   setState2(() {
          //                                     regiondropDownValue =
          //                                         newValue as String?;

          //                                     doctorarea(newValue!);
          //                                   });
          //                                   setState3(() {
          //                                     regiondropDownValue =
          //                                         newValue as String?;
          //                                   });
          //                                 },
          //                               );
          //                             }),
          //                           ),
          //                         ),
          //                         const SizedBox(
          //                           height: 10,
          //                         ),
          //                         const Align(
          //                             alignment: Alignment.centerLeft,
          //                             child: Text("Area")),
          //                         SizedBox(
          //                           height: 50,
          //                           width: double.infinity,
          //                           child: Card(
          //                             elevation: 8,
          //                             child: StatefulBuilder(builder:
          //                                 (BuildContext context, setState4) {
          //                               return DropdownButton(
          //                                 value: areafinalList.isEmpty
          //                                     ? "ok"
          //                                     : areafinalList.first,

          //                                 icon: const Icon(
          //                                   Icons.keyboard_arrow_down,
          //                                   color: Colors.black,
          //                                 ),

          //                                 // Array list of items
          //                                 items: areafinalList.map((items) {
          //                                   return DropdownMenuItem(
          //                                     value: items,
          //                                     child: Text(
          //                                       items,
          //                                       style: const TextStyle(
          //                                         color: Colors.black,
          //                                         // fontSize: 16,
          //                                       ),
          //                                     ),
          //                                   );
          //                                 }).toList(),
          //                                 disabledHint:
          //                                     Text("Please Select Region"),
          //                                 onChanged: (newValue) {
          //                                   setState2(() {
          //                                     areadropDownValue =
          //                                         newValue as String?;

          //                                     doctorTerrority(newValue!);
          //                                   });
          //                                   setState4(() {
          //                                     areadropDownValue =
          //                                         newValue as String?;
          //                                   });
          //                                 },
          //                               );
          //                             }),
          //                           ),
          //                         ),
          //                         const SizedBox(
          //                           height: 10,
          //                         ),
          //                         const Align(
          //                             alignment: Alignment.centerLeft,
          //                             child: Text("Territory")),
          //                         SizedBox(
          //                           height: 60,
          //                           width: double.infinity,
          //                           child: Card(
          //                             elevation: 8,
          //                             child: StatefulBuilder(builder:
          //                                 (BuildContext context, setState5) {
          //                               return DropdownButton(
          //                                 value: territoryfinalList.isEmpty
          //                                     ? "ok"
          //                                     : terrorDropDownValue,

          //                                 icon: const Icon(
          //                                   Icons.keyboard_arrow_down,
          //                                   color: Colors.black,
          //                                 ),

          //                                 // Array list of items
          //                                 items:
          //                                     territoryfinalList.map((items) {
          //                                   return DropdownMenuItem(
          //                                     value: items,
          //                                     child: Text(
          //                                       items,
          //                                       style: const TextStyle(
          //                                         color: Colors.black,
          //                                         // fontSize: 16,
          //                                       ),
          //                                     ),
          //                                   );
          //                                 }).toList(),
          //                                 disabledHint:
          //                                     Text("Please Select Area"),
          //                                 onChanged: (newValue) {
          //                                   setState2(() {
          //                                     terrorDropDownValue =
          //                                         newValue as String?;
          //                                     Navigator.pop(context);
          //                                     ApiCall().doctorArea(newValue!);
          //                                     print(newValue);
          //                                   });
          //                                   // setState5(() {
          //                                   //   dropDownValue = newValue as String?;
          //                                   //   print(newValue);
          //                                   // });
          //                                 },
          //                               );
          //                             }),
          //                           ),
          //                         ),
          //                         const SizedBox(
          //                           height: 10,
          //                         ),
          //                         Align(
          //                           alignment: Alignment.centerRight,
          //                           child: ElevatedButton(
          //                               onPressed: () {},
          //                               child: const Text("Get Doctor List")),
          //                         )

          //                         // }
          //                         // DropdownButton(
          //                         //     onChanged: (val) {},
          //                         //     items: item
          //                         //         .map((e) => DropdownMenuItem<String>(
          //                         //               value: e,
          //                         //               child: Row(
          //                         //                 children: [
          //                         //                   Icon(
          //                         //                     Icons.exit_to_app,
          //                         //                     color: Colors.black,
          //                         //                   ),
          //                         //                   SizedBox(
          //                         //                     height: 8,
          //                         //                   ),
          //                         //                   Text(e)
          //                         //                 ],
          //                         //               ),
          //                         //             ))
          //                         //         .toList())
          //                       ],
          //                     );
          //                   }),
          //                 ),
          //               );
          //             });
          //       },
          //       icon: Icon(Icons.business))
          // ],
        ),
        // endDrawer: Drawer(
        //   width: screenWidth * 0.7,
        //   child: ListView(
        //     children: [
        //       SizedBox(
        //         height: screenHeight / 3.3,
        //         child: DrawerHeader(
        //           decoration: const BoxDecoration(
        //             color: Colors.blueGrey,
        //           ),
        //           child: Stack(
        //             children: [
        //               Center(
        //                   child: Image.asset('assets/images/mRep7_logo.png')),
        //               Positioned(
        //                 top: 145,
        //                 left: 100,
        //                 child: Text(
        //                   "Pharma-Rx",
        //                   style: TextStyle(
        //                       fontSize: 16,
        //                       color: Color.fromARGB(255, 13, 64, 85),
        //                       fontWeight: FontWeight.w500),
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       DropdownButton(
        //         value: dropDownValue,

        //         icon: const Icon(
        //           Icons.keyboard_arrow_down,
        //           color: Colors.black,
        //         ),

        //         // Array list of items
        //         items: item.map((String items) {
        //           return DropdownMenuItem(
        //             value: items,
        //             child: Text(
        //               items,
        //               style: const TextStyle(
        //                 color: Colors.black,
        //                 // fontSize: 16,
        //               ),
        //             ),
        //           );
        //         }).toList(),

        //         onChanged: (String? newValue) {
        //           setState(() {
        //             dropDownValue = newValue!;
        //           });
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) => runFilter(value),
                      controller: searchController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search Doctor',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) => runFilter(value),
                      controller: searchController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search Doctor',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 9,
              child: foundUsers.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: foundUsers.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext itemBuilder, index) {
                        return GestureDetector(
                          onTap: () {
                            widget.tempList.clear();
                            if (widget.counterForDoctorList == 0) {
                              widget.counterCallback(_doctorCOunter());
                            }

                            if (ok = true) {
                              widget.tempList.add(
                                RxDcrDataModel(
                                    docName: foundUsers[index]['doc_name'],
                                    docId: foundUsers[index]['doc_id'],
                                    areaName: foundUsers[index]['area_name'],
                                    areaId: foundUsers[index]['area_id'],
                                    address: foundUsers[index]['address'],
                                    uiqueKey: widget.counterForDoctorList,
                                    presImage: ''),
                              );

                              widget.tempListFunc(widget.tempList);
                              Navigator.pop(context);
                              ok = false;
                            }

                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (_) => RxPage()));
                          },
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            '${foundUsers[index]['doc_name']} ' +
                                                '(${foundUsers[index]['doc_id']})',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19,
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
                                              '${foundUsers[index]['area_name']}' +
                                                  '(${foundUsers[index]['area_id']}) ,' +
                                                  ' ${foundUsers[index]['address']}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                // fontSize: 19,
                                              ),
                                            ),
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
                      })
                  : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
