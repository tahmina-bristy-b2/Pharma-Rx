// To parse this JSON data, do
//
//     final regionList = regionListFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<RegionList> regionListFromJson(String str) =>
    List<RegionList>.from(json.decode(str).map((x) => RegionList.fromJson(x)));

String regionListToJson(List<RegionList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegionList {
  RegionList({
    required this.regionId,
    required this.regionName,
    required this.areaList,
  });

  String regionId;
  String regionName;
  List<AreaList> areaList;

  factory RegionList.fromJson(Map<String, dynamic> json) => RegionList(
        regionId: json["region_id"],
        regionName: json["region_name"],
        areaList: List<AreaList>.from(
            json["area_list"].map((x) => AreaList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "region_id": regionId,
        "region_name": regionName,
        "area_list": List<dynamic>.from(areaList.map((x) => x.toJson())),
      };
}

class AreaList {
  AreaList({
    required this.areaId,
    required this.areaName,
    required this.territoryList,
  });

  String areaId;
  String areaName;
  List<TerritoryList> territoryList;

  factory AreaList.fromJson(Map<String, dynamic> json) => AreaList(
        areaId: json["area_id"],
        areaName: json["area_name"],
        territoryList: List<TerritoryList>.from(
            json["territory_list"].map((x) => TerritoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "area_id": areaId,
        "area_name": areaName,
        "territory_list":
            List<dynamic>.from(territoryList.map((x) => x.toJson())),
      };
}

class TerritoryList {
  TerritoryList({
    required this.territoryId,
    required this.territoryName,
  });

  String territoryId;
  String territoryName;

  factory TerritoryList.fromJson(Map<String, dynamic> json) => TerritoryList(
        territoryId: json["territory_id"],
        territoryName: json["territory_name"],
      );

  Map<String, dynamic> toJson() => {
        "territory_id": territoryId,
        "territory_name": territoryName,
      };
}
