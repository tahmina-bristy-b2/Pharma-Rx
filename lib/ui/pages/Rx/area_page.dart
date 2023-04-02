// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pharma_rx/services/data_sync/data_sync_and_saveTo_hive.dart';
// import 'package:pharma_rx/ui/pages/Rx/rx_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AreaPage extends StatefulWidget {
//   List areaList;
//   AreaPage({Key? key, required this.areaList}) : super(key: key);

//   @override
//   State<AreaPage> createState() => _AreaPageState();
// }

// class _AreaPageState extends State<AreaPage> {
//   String sync_url = '';
//   String cid = '';
//   String userId = '';
//   String userPassword = '';
//   String userName = '';
//   String user_id = '';
//   bool isLoading = false;
//   String areaId = '';
//   Box? box;

//   @override
//   void initState() {
//     getAreaId();
//     SharedPreferences.getInstance().then((prefs) {
//       sync_url = prefs.getString("sync_url")!;
//       cid = prefs.getString("CID")!;
//       userId = prefs.getString("USER_ID")!;
//       userPassword = prefs.getString("PASSWORD")!;
//       userName = prefs.getString("userName")!;
//       user_id = prefs.getString("user_id")!;
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // setState(() {
//     //   isLoading = false;
//     // });
//     return isLoading
//         ? Container(
//             padding: const EdgeInsets.all(50),
//             color: Colors.white,
//             child: const Center(
//               child: CircularProgressIndicator(),
//             ),
//           )
//         : Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: true,
//               title: const Text('Area Page'),
//               centerTitle: true,
//             ),
//             body: SafeArea(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: widget.areaList.length,
//                 itemBuilder: (BuildContext itemBuilder, index) {
//                   return Card(
//                     elevation: 2,
//                     child: SizedBox(
//                       height: 40,
//                       child: InkWell(
//                         onTap: () async {
//                           if (areaId == widget.areaList[index]['area_id']) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => RxScreen(
//                                   address: '',
//                                   areaId: '',
//                                   areaName: '',
//                                   ck: '',
//                                   dcrKey: 0,
//                                   docId: '',
//                                   docName: '',
//                                   uniqueId: 0,
//                                   draftRxMedicinItem: [],
//                                   image1: '',
//                                 ),
//                               ),
//                             );
//                           } else {
//                             setState(() {
//                               isLoading = true;
//                             });
//                             bool result =
//                                 await InternetConnectionChecker().hasConnection;
//                             if (result == true) {
//                               DataSyncAndSaveToHive().getDcrData(
//                                   sync_url,
//                                   cid,
//                                   userId,
//                                   userPassword,
//                                   widget.areaList[index]['area_id'],
//                                   context);
//                             } else {
//                               setState(() {
//                                 isLoading = false;
//                               });
//                               _submitToastforOrder3();

//                               // print('No internet :( Reason:');
//                               // print(InternetConnectionChecker().lastTryResults);
//                             }
//                             Future.delayed(const Duration(seconds: 10), () {
//                               setState(() {
//                                 isLoading = false;
//                               });
//                               // print("Executed after 5 seconds");
//                             });
//                           }
//                         },
//                         child: Row(
//                           children: [
//                             Expanded(
//                               flex: 9,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child:
//                                     Text(widget.areaList[index]['area_name']),
//                               ),
//                             ),
//                             const Expanded(
//                               flex: 1,
//                               child: Icon(
//                                 Icons.arrow_forward_ios_sharp,
//                                 color: Colors.green,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
//   }

//   Future getAreaId() async {
//     var dir = await getApplicationDocumentsDirectory();
//     Hive.init(dir.path);
//     box = await Hive.openBox('AreaId');
//     setState(() {
//       areaId = box!.get('areaId') ?? '';
//     });
//   }

//   void _submitToastforOrder3() {
//     Fluttertoast.showToast(
//         msg: 'No Internet Connection\nPlease check your internet connection.',
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.SNACKBAR,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }
// }
