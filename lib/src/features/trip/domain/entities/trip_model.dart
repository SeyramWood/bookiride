// To parse this JSON data, do
//
//     final tripModel = tripModelFromJson(jsonString);
// To parse this JSON data, do
//
//     final tripModel = tripModelFromJson(jsonString);

import 'dart:convert';

import '../../../../shared/constant/model.dart';

TripModel tripModelFromJson(String str) => TripModel.fromJson(json.decode(str));

String tripModelToJson(TripModel data) => json.encode(data.toJson());

class TripModel {
  Data? data;
  bool status;

  TripModel({
    required this.data,
    required this.status,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
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
  List<Trip>? trips;

  Data({
    required this.count,
    required this.trips,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"] ?? 0,
        trips:
            List<Trip>.from(json["data"]?.map((x) => Trip.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "data": List<dynamic>.from(trips?.map((x) => x.toJson()) ?? []),
      };
}

class Trip {
  int id;
  DateTime departureDate;
  DateTime arrivalDate;
  dynamic returnDate;
  String type;
  InspectionStatus inspectionStatus;
  String status;
  bool scheduled;
  int seatLeft;
  int rate;
  int discount;
  Terminal terminal;
  Vehicle vehicle;
  Route route;
  Driver driver;
  Company company;
  dynamic bookings;
  DateTime createdAt;
  DateTime updatedAt;
  

  Trip({
    required this.id,
    required this.departureDate,
    required this.arrivalDate,
    required this.returnDate,
    required this.type,
    required this.inspectionStatus,
    required this.status,
    required this.scheduled,
    required this.seatLeft,
    required this.terminal,
    required this.vehicle,
    this.bookings,
    required this.rate,
    required this.discount,
    required this.route,
    required this.driver,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json["id"],
        departureDate: DateTime.parse(json["departureDate"]),
        arrivalDate: DateTime.parse(json["arrivalDate"]),
        returnDate: json["returnDate"] ?? '',
        type: json["type"],
        inspectionStatus: InspectionStatus.fromJson(json["inspectionStatus"]),
        status: json["status"] ?? '',
        rate: json['rate'] ?? 0,
        discount: json['discount'] ?? 0,
        scheduled: json["scheduled"],
        seatLeft: json["seatLeft"] ?? 0,
        terminal: Terminal.fromJson(json["terminal"] ?? {}),
        vehicle: Vehicle.fromJson(json["vehicle"]),
        route: Route.fromJson(json["route"]),
        driver: Driver.fromJson(json["driver"]),
        company: Company.fromJson(json["company"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        bookings: json['bookings'] ?? {},
        // delivery: json['delivery'] ?? {},
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "departureDate": departureDate.toIso8601String(),
        "arrivalDate": arrivalDate.toIso8601String(),
        "returnDate": returnDate,
        "type": type,
        "inspectionStatus": inspectionStatus.toJson(),
        "status": status,
        "scheduled": scheduled,
        "seatLeft": seatLeft,
        "vehicle": vehicle.toJson(),
        "route": route.toJson(),
        "driver": driver.toJson(),
        "company": company.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Terminal {
  From from;
  From to;

  Terminal({
    required this.from,
    required this.to,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) => Terminal(
        from: From.fromJson(json["from"]),
        to: From.fromJson(json["to"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from.toJson(),
        "to": to.toJson(),
      };
}

class From {
  int id;
  String name;

  From({
    required this.id,
    required this.name,
  });

  factory From.fromJson(Map<String, dynamic> json) => From(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
