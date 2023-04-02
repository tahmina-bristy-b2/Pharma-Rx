// ignore_for_file: non_constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';
part 'hive_data_model.g.dart';

@HiveType(typeId: 0)
class RxDcrDataModel extends HiveObject {
  @HiveField(0)
  int uiqueKey;
  @HiveField(1)
  String docName;
  @HiveField(2)
  String docId;
  @HiveField(3)
  String areaId;
  @HiveField(4)
  String areaName;
  @HiveField(5)
  String address;
  @HiveField(6)
  String presImage;

  RxDcrDataModel({
    required this.uiqueKey,
    required this.docName,
    required this.docId,
    required this.areaId,
    required this.areaName,
    required this.address,
    required this.presImage,
  });
}

@HiveType(typeId: 1)
class MedicineListModel extends HiveObject {
  @HiveField(0)
  int uiqueKey;
  @HiveField(1)
  String strength;
  @HiveField(2)
  String name;
  @HiveField(3)
  String brand;
  @HiveField(4)
  String company;
  @HiveField(5)
  String formation;
  @HiveField(6)
  String generic;
  @HiveField(7)
  String itemId;
  @HiveField(8)
  int quantity;

  MedicineListModel({
    required this.uiqueKey,
    required this.strength,
    required this.brand,
    required this.company,
    required this.formation,
    required this.name,
    required this.generic,
    required this.itemId,
    required this.quantity,
  });
}
