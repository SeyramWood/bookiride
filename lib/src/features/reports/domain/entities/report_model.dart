// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bookihub/src/shared/constant/model.dart';

import '../../../trip/domain/entities/trip_model.dart';

class ReportingModel {
  final String time;
  final String location;
  final String description;
  final int tripId;
  final int driverId;
  final List<File> images;
  final File? voiceNote;
  final String type;

  ReportingModel({
    required this.time,
    required this.location,
    required this.description,
    required this.tripId,
    required this.driverId,
    required this.images,
    required this.voiceNote,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'location': location,
      'description': description,
      'tripId': tripId,
      'driverId': driverId,
      'image': images,
      'voiceNote': voiceNote,
      'type': type,
    };
  }
}

// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

ReportModel reportModelFromJson(String str) =>
    ReportModel.fromJson(json.decode(str));

class ReportModel {
  Data data;
  bool status;

  ReportModel({
    required this.data,
    required this.status,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        data: Data.fromJson(json["data"] ?? {}),
        status: json["status"],
      );
}

class Data {
  int count;
  List<Report> data;

  Data({
    required this.count,
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"] ?? 0,
        data: List<Report>.from(
            json["data"]?.map((x) => Report.fromJson(x)) ?? []),
      );
}

class Report {
  int id;
  DateTime time;
  String location;
  String? type;
  String description;
  String? audio;
  List<VImage> images;
  ReportStatus status;
  Trip? trip;

  DateTime createdAt;
  DateTime updatedAt;

  Report({
    required this.id,
    required this.time,
    required this.type,
    required this.status,
    required this.location,
    required this.description,
    required this.audio,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json["id"],
        time: DateTime.parse(json["time"]),
        location: json["location"] ?? '',
        type: json["type"] ?? '',
        description: json["description"] ?? '',
        audio: json["audio"] ?? '',
        status: reportStatusValues.map[json["status"]]!,
        images:
            List<VImage>.from(json["images"].map((x) => VImage.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}

enum ReportStatus { Pending, Resolved }

final reportStatusValues = EnumValues({
  "resolved": ReportStatus.Resolved,
  "pending": ReportStatus.Pending,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
