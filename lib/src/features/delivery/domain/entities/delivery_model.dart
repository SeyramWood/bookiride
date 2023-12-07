// To parse this JSON data, do
//
//     final deliveryModel = deliveryModelFromJson(jsonString);

import 'dart:convert';

import '../../../../shared/constant/model.dart';

DeliveryModel deliveryModelFromJson(String str) =>
    DeliveryModel.fromJson(json.decode(str));

String deliveryModelToJson(DeliveryModel data) => json.encode(data.toJson());

class DeliveryModel {
  Data? data;
  bool status;

  DeliveryModel({
    required this.data,
    required this.status,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) => DeliveryModel(
        data: Data.fromJson(json["data"] ?? {}),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "status": status,
      };
}

class Data {
  int count;
  List<Delivery> delivery;

  Data({
    required this.count,
    required this.delivery,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"] ?? 0,
        delivery: List<Delivery>.from(
            json["data"]?.map((x) => Delivery.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "data": List<dynamic>.from(delivery.map((x) => x.toJson())),
      };
}

class Delivery {
  int id;
  String packageCode;
  String senderName;
  String senderPhone;
  String recipientName;
  String recipientPhone;
  String recipientLocation;
  String transType;
  String status;
  List<VImage> packageImages;
  List<dynamic> recipientImages;
  dynamic transaction;
  String weight;
  dynamic trip;
  DateTime createdAt;
  DateTime updatedAt;

  Delivery({
    required this.id,
    required this.packageCode,
    required this.senderName,
    required this.senderPhone,
    required this.recipientName,
    required this.recipientPhone,
    required this.recipientLocation,
    required this.transType,
    required this.status,
    required this.packageImages,
    required this.recipientImages,
    required this.createdAt,
    required this.updatedAt,
    required this.weight,
    this.transaction,
    this.trip,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        id: json["id"] ?? 0,
        packageCode: json["packageCode"],
        senderName: json["senderName"],
        senderPhone: json["senderPhone"],
        recipientName: json["recipientName"],
        recipientPhone: json["recipientPhone"],
        recipientLocation: json["recipientLocation"],
        transType: json["type"],
        weight: json["type"],
        status: json["status"],
        packageImages: List<VImage>.from(
            json["packageImages"]?.map((x) => VImage.fromJson(x)) ?? []),
        recipientImages:
            List<dynamic>.from(json["recipientImages"]?.map((x) => x) ?? []),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        transaction: json['transaction'],
        trip: json['trip'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "packageCode": packageCode,
        "senderName": senderName,
        "senderPhone": senderPhone,
        "recipientName": recipientName,
        "recipientPhone": recipientPhone,
        "recipientLocation": recipientLocation,
        // "amount": amount,
        "transType": transType,
        "status": status,
        "packageImages":
            List<dynamic>.from(packageImages.map((x) => x.toJson())),
        "recipientImages": List<dynamic>.from(recipientImages.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
