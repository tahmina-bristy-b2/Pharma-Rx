import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:pharma_rx/ui/pages/loginPage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cidController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;
  String? oldPass;
  String? userId;
  String? cid;
  String? deviceId;
  String? sync_url;
  String? change_pass_url;
  var statusCode;
  bool obscureOldPassword = false;
  bool obscureNewPassword = false;
  bool obscureConfirmPassword = false;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      oldPass = prefs.getString("PASSWORD");
      cid = prefs.getString("CID");
      deviceId = prefs.getString("deviceId");
      // print('deviceId=$deviceId');
      userId = prefs.getString("USER_ID");
      sync_url = prefs.getString("sync_url")!;
      change_pass_url = prefs.getString("change_pass_url");
      setState(() {
        _cidController.text = cid!;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _cidController.dispose();
    _userIdController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 201, 149),
        title: Text("Change password"),
        titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        // title: const Text("Reset password"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                // height: 8,
                child: Form(
                  key: _formKey,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: TextFormField(
                              autofocus: false,
                              controller: _cidController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Provide Your Company Id';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Work Company Id',
                                labelStyle: TextStyle(color: Colors.blueGrey),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: TextFormField(
                              autofocus: false,
                              controller: _userIdController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Provide Your User Id';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  labelText: 'User Id',
                                  labelStyle: TextStyle(color: Colors.blueGrey),
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: TextFormField(
                              autofocus: false,
                              controller: _oldPasswordController,
                              obscureText: obscureOldPassword,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Provide Your Old Password';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Old Password',
                                  labelStyle: TextStyle(color: Colors.blueGrey),
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: TextFormField(
                              autofocus: false,
                              controller: _newPasswordController,
                              obscureText: obscureNewPassword,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Provide Your New Password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                labelStyle:
                                    const TextStyle(color: Colors.blueGrey),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                    onPressed: () => setState(() =>
                                        obscureNewPassword =
                                            !obscureNewPassword),
                                    icon: Icon(
                                      obscureNewPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: TextFormField(
                              autofocus: false,
                              controller: _confirmPasswordController,
                              obscureText: obscureConfirmPassword,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Provide Your Confirm Password';
                                }
                                if (value != _newPasswordController.text) {
                                  return 'Confirm Password Didn\'t Match';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle:
                                    const TextStyle(color: Colors.blueGrey),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() => obscureConfirmPassword =
                                        !obscureConfirmPassword);
                                  },
                                  icon: Icon(obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    ResetPass();
                    if (statusCode != 200) {
                      buildShowDialog(context);
                    }
                  }
                },
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width / 1.5,
                    // width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xff70BA85)),
                    child: const Text(
                      'Update Password',
                      style: TextStyle(
                          color: Color.fromARGB(206, 7, 3, 3),
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future ResetPass() async {
    final response = await http.post(
      Uri.parse('$change_pass_url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "cid": cid!,
        "user_id": userId!,
        "user_pass": oldPass!,
        "device_id": deviceId!,
        "old_pass": _oldPasswordController.text,
        "new_pass": _newPasswordController.text,
        "con_pass": _confirmPasswordController.text,
      }),
    );

    statusCode = response.statusCode;
    if (statusCode == 200) {
      // var data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Completed Reset Password')));
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      // print('reset');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('InCompleted Reset Password')));
    }
    return "Null";
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }
}
