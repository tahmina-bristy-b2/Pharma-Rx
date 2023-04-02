// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pharma_rx/services/apiCall.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RxReportScreen extends StatefulWidget {
  String report_url;
  String cid;
  String userId;
  String userPassword;
  RxReportScreen(
      {Key? key,
      required this.report_url,
      required this.cid,
      required this.userId,
      required this.userPassword})
      : super(key: key);

  @override
  State<RxReportScreen> createState() => _RxReportScreenState();
}

class _RxReportScreenState extends State<RxReportScreen> {
  TextEditingController dateController = TextEditingController();
  List reportRecord = [];
  DateTime dateTime = DateTime.now();
  num sumofCount = 0;
  double progress = 0;
  String? deviceId = '';

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      deviceId = prefs.getString("deviceId");
      // deviceBrand = prefs.getString("deviceBrand");
      // deviceModel = prefs.getString("deviceModel");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 138, 201, 149),
          title: const Text('Rx Report'),
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 27, 56, 34),
              fontWeight: FontWeight.w500,
              fontSize: 20),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Text("Daile Summary"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final date = await pickDate();
                  if (date == null) {
                    return;
                  } else {
                    setState(
                      () {
                        dateTime = date;
                      },
                    );
                  }
                },
                controller: dateController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Date',
                  labelText:
                      "${dateTime.year}-${dateTime.month}-${dateTime.day}",
                  labelStyle: const TextStyle(color: Colors.black),
                  suffixIcon:
                      Icon(Icons.calendar_today, color: Colors.blue[400]),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    var reportData = await ApiCall().getReport(
                        "${dateTime.year}-${dateTime.month}-${dateTime.day}");
                    reportRecord = reportData["res_data"]["records"];
                    // if (sumofCount == 0) {
                    sumofCount = 0;
                    for (var person in reportRecord) {
                      
                      sumofCount += person["prCount"];
                    }
                    print(sumofCount);
                    // }
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 50, 127, 190)),
                  child: const Text("Show Summary"),
                ),
              ),
            ),
            SizedBox(height: screenHeight / 16),

            Container(
              color: const Color.fromARGB(255, 212, 254, 255),
              height: screenHeight / 1.9,
              width: screenWidth,
              child: SingleChildScrollView(
                child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromARGB(255, 156, 241, 174)),
                    dividerThickness: 3,
                    columnSpacing: 2,
                    // headingRowColor:
                    //     MaterialStateColor.resolveWith((states) => Colors.blue),
                    // dataRowColor:
                    //     MaterialStateColor.resolveWith((states) => Colors.grey),
                    // decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       begin: Alignment.centerLeft,
                    //       end: Alignment.centerRight,
                    //       // 10% of the width, so there are ten blinds.
                    //       colors: <Color>[
                    //         Colors.white,
                    //         Colors.blue,
                    //         Color.fromARGB(255, 240, 219, 219),
                    //       ],
                    //       // red to yellow
                    //       tileMode: TileMode
                    //           .repeated, // repeats the gradient over the canvas
                    //     ),
                    //     border: Border.all(color: Colors.white, width: 2),
                    //     borderRadius: BorderRadius.circular(16)),
                    // // columnSpacing: 9,
                    columns: const [
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Text(
                            "Territory",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Doctor Name",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Text(
                            "Qt",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                    rows: reportRecord.map((e) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              e["territory_name"].toString(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ),
                          DataCell(
                            Text(
                              e["doctor_name"].toString(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Text(
                                e["prCount"].toString(),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList()

                    // [
                    //   DataRow(
                    //     cells: [
                    //       DataCell(
                    //         Text("ok"),
                    //       ),
                    //       DataCell(
                    //         Text("ok"),
                    //       ),
                    //       DataCell(
                    //         Text("ok"),
                    //       ),
                    //     ],
                    //   )
                    // ],
                    ),
              ),
            ),
            const Spacer(),
            Container(
              color: const Color(0xff70BA85).withOpacity(.3),
              height: screenHeight / 10,
              child: Row(
                children: [
                  const Expanded(flex: 3, child: Text("")),
                  const Expanded(
                      flex: 2,
                      child: Text(
                        "Total",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: Text(sumofCount.toString(),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ))
                ],
              ),
            )
          ],
        )
        // Stack(
        //   children: [
        //     Align(
        //       alignment: Alignment.center,
        //       child: SafeArea(
        //         child: Center(
        //           child: InAppWebView(
        //             initialUrlRequest: URLRequest(
        //                 url: Uri.parse(
        //                     // 'http://w05.yeapps.com/hamdard/report_seen_rx_mobile/index?cid=HAMDARD&rep_id=itmso&rep_pass=1234'

        //                     widget.report_url +
        //                         "report_seen_rx_mobile/index?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}&device_id=$deviceId")),
        //             onReceivedServerTrustAuthRequest:
        //                 (controller, challenge) async {
        //               // print(challenge);
        //               return ServerTrustAuthResponse(
        //                   action: ServerTrustAuthResponseAction.PROCEED);
        //             },
        //             onProgressChanged:
        //                 (InAppWebViewController controller, int progress) {
        //               setState(() {
        //                 this.progress = progress / 100;
        //               });
        //             },
        //           ),
        //         ),
        //       ),
        //     ),
        //     Align(alignment: Alignment.topCenter, child: _buildProgressBar()),
        //   ],
        // ),
        );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1990),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: Colors.white,
                surface: Colors.blue,
              ),
              // dialogBackgroundColor: Colors.white,
            ), // This will change to light theme.
            child: child!,
          );
        },
      );

  Widget _buildProgressBar() {
    if (progress != 1.0) {
      // return const CircularProgressIndicator();
// You can use LinearProgressIndicator also
      return LinearProgressIndicator(
        value: progress,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
        backgroundColor: Colors.blue,
        minHeight: 7,
      );
    }
    return Container();
  }
}
