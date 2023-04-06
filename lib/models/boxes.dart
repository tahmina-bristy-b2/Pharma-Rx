import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharma_rx/models/dmpath_data_model.dart';
import 'package:pharma_rx/models/hive_data_model.dart';
import 'package:pharma_rx/models/login_data_model.dart';
import 'package:pharma_rx/models/others_data_model.dart';

class Boxes {
  static Box<RxDcrDataModel> rxdDoctor() => Hive.box('RxdDoctor');
  static Box<MedicineListModel> getMedicine() => Hive.box('draftMdicinList');
  static Box<DmPathDataModel> getDmPathDataModel() =>
      Hive.box('dmpathDataList');
  static Box<LoginDataModel> getLoginDataModel() => Hive.box('loginDataInfo');
  static Box<OthersDataModel> getOthersDataModel() => Hive.box('othersData');
}
