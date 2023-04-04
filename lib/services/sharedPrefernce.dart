import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferncesMethod {
  Future<void> sharedPreferenceSetDataForLogin(
    String cid,
    String userid,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('CID', cid);
    await prefs.setString('USER_ID', userid);
    // await prefs.setString('PASSWORD', password);
  }
}
