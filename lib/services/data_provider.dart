import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:pharma_rx/services/apis.dart';

class Dataproviders {
  dmpathResponse(String cid) async {
    final http.Response response;
    response = await http.get(
      Uri.parse(Apis().dmPath(cid)),
    );
    return response;
  }

  loginResponse(
      String? deviceId,
      String? deviceBrand,
      String? deviceModel,
      String cid,
      String userId,
      String password,
      String loginUrl,
      String version) async {
    final http.Response response;
    response = await http.get(
      Uri.parse(Apis().login(deviceId, deviceBrand, deviceModel, cid, userId,
          password, loginUrl, version)),
    );
    return response;
  }
}
