class Apis {
  String dmPath(String cid) =>
      // 'http://w03.yeapps.com/dmpath/dmpath_test/get_dmpath?cid=$cid';
      "http://w03.yeapps.com/dmpath/dmpath_rx_101/get_dmpath?cid=$cid";
  String login(
          String? deviceId,
          String? deviceBrand,
          String? deviceModel,
          String cid,
          String userId,
          String password,
          String loginUrl,
          String version) =>
      '$loginUrl?cid=$cid&user_id=$userId&user_pass=$password&device_id=$deviceId&device_brand=$deviceBrand&device_model=$deviceModel&app_v=$version';
}
