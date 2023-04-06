import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharma_rx/models/hive_data_model.dart';
import 'package:photo_view/photo_view.dart';

String searchControlled = "";
final GlobalKey<ScaffoldState> medkey = GlobalKey();

class MedicinListScreen extends StatefulWidget {
  List medicineData;
  List<MedicineListModel> tempList;
  int counter;
  File? img;
  String img1;
  Function(List<MedicineListModel>) tempListFunc;

  MedicinListScreen({
    Key? key,
    required this.medicineData,
    required this.tempList,
    required this.counter,
    required this.tempListFunc,
    required this.img,
    required this.img1,
  }) : super(key: key);

  @override
  State<MedicinListScreen> createState() => _MedicinListScreenState();
}

class _MedicinListScreenState extends State<MedicinListScreen> {
  Box? box;
  List syncItemList = [];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController medicineController = TextEditingController();
  List<MedicineListModel> newItem = [];
  List finalAdd = [];
  List foundUsers = [];
  bool ok = true;
  bool value = false;
  String? tempId;
  var selectedMed;
  Map pressedActivity = {};
  bool medAdd = false;
  int _currentSelected = 2;
  int items = 0;
  var data = 0;

  @override
  void initState() {
    print("kkkkkkkkkkkkkkk:$finalAdd");
    if (widget.tempList.isNotEmpty) {
      items = widget.tempList.length;
    }
    foundUsers = widget.medicineData;

    foundUsers.forEach((element) {
      pressedActivity[element["item_id"]] = false;
    });
    if (searchControlled != "") {
      setState(() {
        searchController.text = searchControlled;
        runFilter(searchController.text);
      });
    }
    print(searchControlled);

    super.initState();
  }

  @override
  void dispose() {
    medicineController.dispose();
    super.dispose();
  }

  // numberOfFinalMed() {
  //   var number = 0;
  //   List idFAList = [];
  //   List idWTList = [];
  //   String newId;
  //   widget.tempList.forEach((element) {
  //     idWTList.add(element.itemId);
  //   });
  //   finalAdd.forEach((item) {
  //     idFAList.add(item["item_id"]);
  //   });
  //   for (int l = 0; l < idFAList.length; l++) {
  //     newId = idFAList[l];
  //     if (idWTList.contains(newId)) {
  //       number = idWTList.length;
  //     } else {
  //       idWTList.add(newId);

  //       number = idWTList.length;
  //     }
  //   }
  //   number = idWTList.length;
  //   return number;
  // }

  void runFilter(String enteredKeyword) {
    foundUsers = widget.medicineData;
    searchControlled = enteredKeyword;
    print(searchControlled);

    List results = [];

    var starts = foundUsers
        .where((s) =>
            s['name'].toLowerCase().startsWith(enteredKeyword.toLowerCase()))
        .toList();

    var contains = foundUsers
        .where((s) =>
            s['name'].toLowerCase().contains(enteredKeyword.toLowerCase()) &&
            !s['name'].toLowerCase().startsWith(enteredKeyword.toLowerCase()))
        .toList()
      ..sort(
          (a, b) => a['name'].toLowerCase().compareTo(b['name'].toLowerCase()));

    results = [...starts, ...contains];
    // }

    // Refresh the UI
    setState(() {
      foundUsers = results;
    });
  }

  // late List<bool> pressedAttentions = foundUsers.map((e) => false).toList();

  void _onItemTapped(int index) async {
    if (index == 0) {
      // setState(() {
      //   _isLoading = false;
      // });
      // orderSubmit();

      setState(() {
        _currentSelected = index;
      });
    }

    if (index == 1) {
      // putAddedRxData();

      setState(() {
        _currentSelected = index;
      });
    }

    if (index == 2) {
      setState(() {
        _currentSelected = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await addMedicine(context);
        return false;
      },
      child: Scaffold(
        key: medkey,
        resizeToAvoidBottomInset: false,
        endDrawerEnableOpenDragGesture: true,
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 138, 201, 149),
          title: const Text('Rx Medicine List Page'),
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 27, 56, 34),
              fontWeight: FontWeight.w500,
              fontSize: 20),
          centerTitle: true,
        ),

        endDrawer: buildDrawerWidget(context),

        body: Column(
          children: [
            widget.img == null
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width / 1,
                    child: PhotoView(
                      imageProvider: FileImage(File(widget.img1)),
                      enableRotation: true,
                      filterQuality: FilterQuality.high,
                      enablePanAlways: false,
                      maxScale: 4.0,
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width / 1,
                    child: PhotoView(
                      imageProvider: FileImage(widget.img!),
                      enableRotation: true,
                      filterQuality: FilterQuality.high,
                      enablePanAlways: false,
                      maxScale: 4.0,
                    ),
                  ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // medAdd = true;

        //     // print("med add hbe ${medAdd}");
        //   },
        //   child: const Text('Add'),
        // ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 8, 16),
                  child: InkWell(
                    onTap: () {
                      // showModalBottomSheet(
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(20)),
                      //   context: context,
                      //   builder: (context) => SizedBox(
                      //     height: MediaQuery.of(context).size.height * 0.25,
                      //     width: MediaQuery.of(context).size.width * 0.5,
                      //     child: Column(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.all(20.0),
                      //           child: TextField(
                      //             keyboardType: TextInputType.text,
                      //             inputFormatters: <TextInputFormatter>[
                      //               FilteringTextInputFormatter.allow(
                      //                   RegExp("[0-9a-zA-Z]")),
                      //             ],
                      //             controller: medicineController,
                      //             decoration: InputDecoration(
                      //               prefixIcon: const Icon(Icons.medication),
                      //               label: const Text("Add New Medicine"),
                      //               filled: true,
                      //               fillColor: const Color(0xFFE2EFDA),
                      //               border: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(5),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      //           child: ElevatedButton(
                      //             onPressed: () async {
                      //               // SharedPreferences prefs =
                      //               //     await SharedPreferences.getInstance();
                      //               // var username = prefs.getString("userName");
                      //               setState(() {
                      //                 addOrphanMedicine();
                      //               });
                      //             },
                      //             style: ElevatedButton.styleFrom(
                      //                 // fixedSize: const Size(20, 50),
                      //                 primary: const Color.fromARGB(
                      //                     255, 105, 204, 221),
                      //                 onPrimary:
                      //                     const Color.fromARGB(255, 49, 47, 47)),
                      //             child: const Text("Add Medicine"),
                      //           ),
                      //         ),

                      //       ],
                      //     ),
                      //   ),
                      // );
                      showDialog(
                          context: context,
                          builder: (context) {
                            var height = MediaQuery.of(context).size.height;
                            var width = MediaQuery.of(context).size.width;
                            return SizedBox(
                                child: AlertDialog(
                              alignment: Alignment.bottomCenter,

                              // ignore: unnecessary_null_comparison
                              content: SizedBox(
                                  height: height * 0.2,
                                  width: width,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: TextField(
                                          keyboardType: TextInputType.text,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9a-zA-Z]")),
                                          ],
                                          controller: medicineController,
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                const Icon(Icons.medication),
                                            label:
                                                const Text("Add New Medicine"),
                                            filled: true,
                                            fillColor: const Color(0xFFE2EFDA),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 8, 20, 8),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            // SharedPreferences prefs =
                                            //     await SharedPreferences.getInstance();
                                            // var username = prefs.getString("userName");
                                            setState(() {
                                              addOrphanMedicine();
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              // fixedSize: const Size(20, 100),
                                              // primary: Color.fromARGB(255, 43, 122, 161),
                                              ),
                                          child: const Text("Add Medicine"),
                                        ),
                                      )
                                    ],
                                  )),
                            ));
                          });
                    },
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset(
                              "assets/images/add_medicine.png",
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            )),
                        const Text('New Medicine')
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    addMedicine(context);
                  },
                  child: Column(
                    children: [
                      Text(""),
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                "assets/images/done.png",
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              )),
                          Positioned(
                              child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child: Text(
                              // numberOfFinalMed().toString(),
                              finalAdd.isNotEmpty
                                  ? data.toString()
                                  : items.toString(),
                              style: TextStyle(color: Colors.white),
                            )),
                          )),
                        ],
                      ),
                      const Text('Done')
                    ],
                  ),
                ),

                InkWell(
                  onTap: () {
                    print("drawer");
                    // Scaffold.of(context).openEndDrawer;
                    // medkey.currentState!.openDrawer();
                    medkey.currentState!.openEndDrawer();

                    // buildDrawerWidget(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 18, 16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 13,
                        ),
                        Image.asset(
                          "assets/images/cap.png",
                          height: 45,
                          width: 40,
                          fit: BoxFit.cover,
                          // color: Colors.blue,
                        ),
                        Text("Medicine")
                      ],
                    ),
                  ),
                ),
                // Padding(
                //     padding: const EdgeInsets.fromLTRB(8, 8, 18, 16),
                //     child: ElevatedButton(
                //       child: Image.asset(
                //         "assets/images/cap.png",
                //         height: 20,
                //         width: 20,
                //       ),
                //       onPressed: () {
                //         print("drawer");
                //         // Scaffold.of(context).openEndDrawer;
                //         // medkey.currentState!.openDrawer();
                //         medkey.currentState!.openEndDrawer();
                //         // buildDrawerWidget(context);
                //       },
                //     )

                //  IconButton(
                //   onPressed: () {
                //     print("drawer");
                //     // Scaffold.of(context).openEndDrawer;
                //     // medkey.currentState!.openDrawer();
                //     medkey.currentState!.openEndDrawer();
                //     // buildDrawerWidget(context);
                //   },
                //   icon: const Icon(
                //     Icons.check,
                //     color: Colors.blue,
                //     size: 35,
                //   ),
                // ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDrawerWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await addMedicine(context);
        return false;
      },
      child: SafeArea(
        child: Drawer(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Column(
            // Important: Remove any padding from the ListView.
            // padding: EdgeInsets.zero,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      // if (searchControlled != "") {
                      //   runFilter(searchControlled);
                      // } else {
                      runFilter(value);
                      // }
                    },
                    autofocus: searchControlled != "" ? true : false,
                    controller: searchController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Search Medicine',
                      suffixIcon: searchController.text.isEmpty &&
                              searchController.text == ''
                          ? const Icon(Icons.search)
                          : IconButton(
                              onPressed: () {
                                searchController.clear();
                                runFilter('');
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black,
                                // size: 28,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              foundUsers.isNotEmpty
                  ? Expanded(
                      flex: 9,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: foundUsers.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final pressAttention =
                                pressedActivity[foundUsers[index]['item_id']];

                            return GestureDetector(
                              onTap: () {
                                // PressAttention = bool? where its selected == true, unselected == false, according to  item id of the list

                                setState(() => pressedActivity[foundUsers[index]
                                    ['item_id']] = !pressAttention!);

                                selectedMed = foundUsers[index];
                                if (pressedActivity[selectedMed['item_id']] ==
                                    true) {
                                  finalAdd.add(selectedMed);
                                } else {
                                  finalAdd.remove(selectedMed);
                                }
                                mycount();
                                // print(selectedMed);
                                // print(finalAdd);
                                // mycount(finalAdd);
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.white70, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      // flex: 9,
                                      child: Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: pressAttention!
                                              ? const Color(0xff70BA85)
                                                  .withOpacity(.7)
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '${foundUsers[index]['name']} ',
                                                    // '(${foundUsers[index]['item_id']})',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 30, 66, 77),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  : const Text(
                      'No data found',
                      style: TextStyle(fontSize: 24),
                    ),
              // DrawerHeader(
              //   decoration: const BoxDecoration(
              //     color: Color.fromARGB(255, 138, 201, 149),
              //   ),
              //   child: Image.asset('assets/images/mRep7_logo.png'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  addMedicine(context) {
    // print(finalAdd);
    // setState(() =>
    //                   pressedActivity[foundUsers[index]['item_id']] =
    //                       !pressAttention!);
    // if (pressedActivity[selectedMed['item_id']] == true) {
    finalAdd.forEach((element) {
      final temp = MedicineListModel(
          strength: element['strength'],
          name: element['name'],
          generic: element['generic'],
          brand: element['brand'],
          company: element['company'],
          formation: element['formation'],
          uiqueKey: widget.counter,
          itemId: element['item_id'],
          quantity: 1);
      final tempItemId = temp.itemId;
      print(temp);

      widget.tempList.removeWhere((item) => item.itemId == tempItemId);

      widget.tempList.add(temp);
    });

    // }
    //  else {
    //   finalAdd.forEach((element) {
    //     final temp = MedicineListModel(
    //         strength: element['strength'],
    //         name: element['name'],
    //         generic: element['generic'],
    //         brand: element['brand'],
    //         company: element['company'],
    //         formation: element['formation'],
    //         uiqueKey: widget.counter,
    //         itemId: element['item_id'],
    //         quantity: 1);
    //     final tempItemId = temp.itemId;
    //     widget.tempList.removeWhere((item) => item.itemId == tempItemId);
    //   });
    // }
    widget.tempListFunc(widget.tempList);

    Navigator.pop(context);
  }

  mycount() {
    finalAdd.forEach((element) {
      final temp = MedicineListModel(
          strength: element['strength'],
          name: element['name'],
          generic: element['generic'],
          brand: element['brand'],
          company: element['company'],
          formation: element['formation'],
          uiqueKey: widget.counter,
          itemId: element['item_id'],
          quantity: 1);
      setState(() {
        final tempItemId = temp.itemId;

        widget.tempList.removeWhere((item) => item.itemId == tempItemId);
        widget.tempList.add(temp);
      });
      data = widget.tempList.length;
      //  widget.tempListFunc(widget.tempList);
    });

    setState(() {
      items = data;
    });
  }

  addOrphanMedicine() {
    final newitem = MedicineListModel(
        strength: "",
        name: medicineController.text,
        generic: "",
        brand: "",
        company: "",
        formation: "",
        uiqueKey: widget.counter,
        itemId: "0",
        quantity: 1);
    // final tempItemId = newitem.itemId;

    // widget.tempList
    //     .removeWhere((item) => item.itemId == tempItemId);

    widget.tempList.add(newitem);
    // print(widget.tempList);

    widget.tempListFunc(widget.tempList);

    medicineController.text = "";
    Navigator.pop(context);
  }
}

class CustomDrawer {
  final Function updateMainScreen;
  CustomDrawer(this.updateMainScreen);
}
