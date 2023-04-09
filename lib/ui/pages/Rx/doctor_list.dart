import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharma_rx/models/hive_data_model.dart';
import 'package:pharma_rx/ui/widgets/alertDialogOrphar.dart';
import 'package:pharma_rx/ui/widgets/alertDialog_terr.dart';

List regionList = [];
List areaListoregion = [];
List areaNameList = [];
List territoryNameList = [];

var body;
var sec;
List result = [];
List territoryList = [];
// ignore: non_constant_identifier_names
List<String> result_two = [];
var doctorName;
String region = "";
String area = " ";
String territory = "";
var newterrorID;
var newterrorIDorpha;
String orpharegion = '';
String orpharea = '';
String orphaterritory = '';
List<RxDcrDataModel> doctorFinalList = [];
List<RxDcrDataModel> doctroList = [];
List regionName = [];

// ignore: must_be_immutable
class DoctorScreen extends StatefulWidget {
  Function(List<RxDcrDataModel>) getList;
  int counterForDoctorList;
  Function counterCallback;
  List<MedicineListModel> medicine;
  String orphanImg;

  DoctorScreen({
    Key? key,
    required this.getList,
    required this.counterForDoctorList,
    required this.counterCallback,
    required this.medicine,
    required this.orphanImg,
  }) : super(key: key);

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  Box? box;
  TextEditingController searchController = TextEditingController();

  List foundUsers = [];

  String? value;
  String? newValue;
  String cid = '';
  String userId = '';
  String userPassword = '';
  String deviceId = "";
  var doctorName = "";
  bool isChanged = false;

  @override
  void initState() {
    // print(widget.counterForDoctorList);

    box = Hive.box("doctorList");

    result = box!.toMap().values.toList(); //!todo Here!df

    // print("orphan doctor${result.length}");
    // print("dddddddddddddddddddd$result");
    print("terrorID $newterrorID");

    SharedPreferences.getInstance().then((prefs) {
      territory = prefs.getString("territory") ?? "";
      region = prefs.getString("region") ?? "";
      area = prefs.getString("area") ?? "";
      if (widget.counterForDoctorList == 0) {
        int? a = prefs.getInt('DCLCounter') ?? 0;

        setState(() {
          widget.counterForDoctorList = a;

          widget.counterCallback(_doctorCOunter());
          // print('doctorcounterafterget: ${widget.counterForDoctorList}');
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
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

  void runFilter(String enteredKeyword) {
    box = Hive.box("doctorList");
    result = box!.toMap().values.toList();

    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users

      results = result;
    } else {
      var starts = result
          .where((s) => s['doc_name']
              .toLowerCase()
              .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = result
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
      result = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Timer(Duration(seconds: 3), () => Navigator.pop(context));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 138, 201, 149),
          title: const Text("Doctor List"),
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 27, 56, 34),
              fontWeight: FontWeight.w500,
              fontSize: 20),
          centerTitle: true,
          actions: [
            ElevatedButton(
                onPressed: () async {
                  print("object=====$territory");
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return TerritoryList(
                          area: area,
                          region: region,
                          territory: territory,
                        );
                      });
                  setState(() {
                    box = Hive.box("doctorList");
                    result = box!.toMap().values.toList();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 138, 201, 149),
                ),
                child: Column(
                  children: const [
                    SizedBox(height: 8),
                    Icon(Icons.travel_explore_rounded),
                    Text("Territory")
                  ],
                ))
          ],
        ),
        body:

            //  ValueListenableBuilder(
            //     valueListenable: Hive.box("doctorList").listenable(),
            //     builder: (BuildContext context, Box box, Widget? child) {
            //       result = box.toMap().values.toList();

            //       return

            Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) => runFilter(value),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Search Doctor',
                        suffixIcon: searchController.text.isEmpty &&
                                searchController.text == ''
                            ? const Icon(Icons.search)
                            : IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  // searchController.text = "";\

                                  runFilter('');
                                  setState(() {
                                    box = Hive.box("doctorList");
                                    result = box!.toMap().values.toList();
                                  });
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            print(widget.medicine.length);
                            return OrphanDoctor(
                              counterForDoctorList: widget.counterForDoctorList,
                              orphanImg: widget.orphanImg,
                              med: widget.medicine,
                            );
                          });
                    },
                    child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.add_box_sharp, size: 40)),
                  ))
                ],
              ),
            ),

            //=========================================================================== */
            //=========================================================================== */
            //=================Search ======================================= */
            //=========================================================================== */
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // const Text(
                      //   "Region :  ",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 17),
                      // ),
                      Text(
                        " $region ",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      // const Text("Area: ",
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 15)),
                      Text(area,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      // const Text("Terrority:  ",
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.w700,
                      //         fontSize: 15)),
                      newterrorID == null
                          ? const Text(
                              " ",
                            )
                          : Text(
                              " $territory",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                    ],
                  )),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: result.length,
                  // result.isEmpty
                  //     ? doctroList.length
                  //     : result.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        doctorFinalList.clear();

                        doctorFinalList.add(
                          RxDcrDataModel(
                              docName: result[index]['doc_name'],
                              docId: result[index]['doc_id'],
                              areaName: result[index]['area_name'],
                              areaId: result[index]['area_id'],
                              address: result[index]['address'],
                              uiqueKey: widget.counterForDoctorList,
                              presImage: ''),
                        );

                        widget.getList(doctorFinalList);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 90,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 7,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      result[index]["doc_name"],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${result[index]["area_name"]}  (${result[index]["area_id"]}),",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${result[index]["address"]}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        )
        //   ;
        // })
        ,
      ),
    );

    //  FutureBuilder(
    //     future: ApiCall().getRegionList(cid, user_id, user_pass, deviceId),
    //     builder: (context, AsyncSnapshot snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         if (snapshot.data == null) {
    //           return Center(
    //             child: Column(
    //               children: const [
    //                 Text("No Data Found"),
    //               ],
    //             ),
    //           );
    //         } else if (snapshot.hasData) {
    //           var data = snapshot.data;

    //           regionList = data["res_data"]["region_list"];
    //           List regionName =
    //               regionList.map((e) => e["region_name"]).toList();

    //           return
    //         } else {
    //           return const Text('Something is wrong');
    //         }
    //       }
    //       return Container(
    //           alignment: Alignment.topCenter,
    //           margin: const EdgeInsets.only(top: 20),
    //           child: const CircularProgressIndicator());
    //     });
  }

  buildShowDialog(BuildContext context, String msg) {
    return showDialog(
        barrierColor: Colors.black,
        barrierDismissible: false,
        context: context,
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
