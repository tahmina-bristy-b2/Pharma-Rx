import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharma_rx/models/hive_data_model.dart';

class Boxes {
  static Box<RxDcrDataModel> rxdDoctor() => Hive.box('RxdDoctor');
  static Box<MedicineListModel> getMedicine() => Hive.box('draftMdicinList');
}
