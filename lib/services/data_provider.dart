import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:pharma_rx/services/apis.dart';

class Dataproviders {
  Future<http.Response> dmpathResponse(String cid) async {
    final http.Response response;
    print("dmpath=${Apis().dmPath(cid)}");
    response = await http.get(
      Uri.parse(Apis().dmPath(cid)),
    );
    return response;
  }

  Future<http.Response> loginResponse(
      String? deviceId,
      String? deviceBrand,
      String? deviceModel,
      String cid,
      String userId,
      String password,
      String loginUrl,
      String version) async {
    final http.Response response;
    print(
        "Login =${Apis().login(deviceId, deviceBrand, deviceModel, cid, userId, password, loginUrl, version)}");
    response = await http.get(
      Uri.parse(Apis().login(deviceId, deviceBrand, deviceModel, cid, userId,
          password, loginUrl, version)),
    );
    return response;
  }
}
