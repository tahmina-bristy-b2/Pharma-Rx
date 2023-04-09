// ignore_for_file: unused_field

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharma_rx/models/boxes.dart';
import 'package:pharma_rx/models/hive_data_model.dart';
import 'package:pharma_rx/ui/pages/Rx/rx_screen.dart';

class RxDraftScreen extends StatefulWidget {
  const RxDraftScreen({Key? key}) : super(key: key);

  @override
  State<RxDraftScreen> createState() => _RxDraftScreenState();
}

class _RxDraftScreenState extends State<RxDraftScreen> {
  // final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  Box? box;

  List itemDraftList = [];
  List<MedicineListModel> addedRxMedicinList = [];
  List<MedicineListModel> filteredMedicin = [];
  List<RxDcrDataModel> dcrDataList = [];
  var screenHeight;
  var screenWidth;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      box = Boxes.getMedicine();
      addedRxMedicinList =
          box!.toMap().values.toList().cast<MedicineListModel>();

      box = Boxes.rxdDoctor();
      dcrDataList = box!.toMap().values.toList().cast<RxDcrDataModel>();

      setState(() {});
    });
    super.initState();
  }

  Future<void> deleteRxDoctor(RxDcrDataModel rxDcrDataModel) async {
    rxDcrDataModel.delete();
  }

  deletRxMedicinItem(int id) {
    final box = Hive.box<MedicineListModel>("draftMdicinList");

    final Map<dynamic, MedicineListModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 138, 201, 149),
          title: const Text('Draft Rx Doctor'),
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 27, 56, 34),
              fontWeight: FontWeight.w500,
              fontSize: 20),
          centerTitle: true),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Boxes.rxdDoctor().listenable(),
          builder: (BuildContext context, Box box, Widget? child) {
            final rxDoctor = box.values.toList().cast<RxDcrDataModel>();

            return genContent(rxDoctor);
          },
        ),
      ),
    );
  }

  Widget genContent(List<RxDcrDataModel> user) {
    if (user.isEmpty) {
      return const Center(
        child: Text(
          "No Data Found",
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: user.length,
        itemBuilder: (BuildContext context, int index) {
          int space = user[index].presImage.indexOf(" ");
          String removeSpace = user[index]
              .presImage
              .substring(space + 1, user[index].presImage.length);
          String finalImage = removeSpace.replaceAll("'", '');
          return GestureDetector(
            onTap: () {},
            child: Card(
              elevation: 10,
              color: const Color.fromARGB(255, 207, 240, 207),
              child: ExpansionTile(
                leading: SizedBox(
                  height: screenHeight / 8,
                  width: screenWidth / 6,
                  child: Image(
                    fit: BoxFit.cover,
                    image: FileImage(File(finalImage)),
                  ),
                ),
                title: Text(
                  "${user[index].docName} ",
                  // "${user[index].docName} (${user[index].docId})  ",
                  maxLines: 2,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text("${user[index].areaName}  "
                    // ${user[index].deliveryDate}   ${user[index].deliveryTime}

                    ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        // onPressed: () => deleteUser(user[index]),
                        onPressed: () {
                          final rxDoctorkey = user[index].uiqueKey;
                          deleteRxDoctor(user[index]);
                          // deleteItem(user[index]);

                          deletRxMedicinItem(rxDoctorkey);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        label: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          final dcrKey = user[index].uiqueKey;
                          // print('dcr:$dcrKey');
                          filteredMedicin = [];
                          addedRxMedicinList
                              .where((item) => item.uiqueKey == dcrKey)
                              .forEach(
                            (item) {
                              print('gsp: ${item.uiqueKey}');
                              final temp = MedicineListModel(
                                  uiqueKey: item.uiqueKey,
                                  strength: item.strength,
                                  brand: item.brand,
                                  company: item.company,
                                  formation: item.formation,
                                  name: item.name,
                                  generic: item.generic,
                                  itemId: item.itemId,
                                  quantity: item.quantity);

                              filteredMedicin.add(temp);
                            },
                          );
                          // print('ami jani na ${user[index].presImage}');

                          // print(ckey);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RxScreen(
                                ck: 'isCheck',
                                dcrKey: dcrKey,
                                uniqueId: user[index].uiqueKey,
                                draftRxMedicinItem: filteredMedicin,
                                docName: user[index].docName,
                                docId: user[index].docId,
                                areaName: user[index].areaName,
                                areaId: user[index].areaId,
                                address: user[index].address,
                                image1: user[index].presImage,
                              ),
                            ),
                          );
                        },
                        // onPressed: () => editUser(user[index]),
                        icon: const Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.blue,
                          // size: 30,
                        ),
                        label: const Text(
                          "Details",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
