import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

List<LatLng> polyList = [];
const String apiKey = "AIzaSyA_qBSnevO4T8L2pW2qaCl13WOVPX9Gb9U";
bool internet = true;
getPolyLines({LatLng? pickUp, LatLng? dropOff}) async {
  polyList.clear();
  String pickLat = "";
  String pickLng = "";
  String dropLat = "";
  String dropLng = ""; 
  pickLat = pickUp!.latitude.toString();
  pickLng = pickUp.longitude.toString();
  dropLat = dropOff!.latitude.toString();
  dropLng = dropOff.longitude.toString();
  try {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$pickLat%2C$pickLng&destination=$dropLat%2C$dropLng&avoid=ferries|indoor&transit_mode=bus&mode=driving&key=$apiKey";
    var response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      print(response.body);
      var steps =
          jsonDecode(response.body)["routes"][0]["overview_polyline"]["points"];
      decodeEncodedPolyLine(encode: steps);
    } else {
      print(response.body);
    }
  } catch (e) {
    if (e is SocketException) {
      // print("No Internet connection");
    }
  }
  return polyList;
} 

///Decode a JSON string
Set<Polyline> polyLine = {};

List<PointLatLng> decodeEncodedPolyLine({String? encode}) {
  List<PointLatLng> poly = [];
  int index = 0, len = encode!.length;
  int lat = 0, lng = 0;
  polyLine.clear();
  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encode.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;
    shift = 0;
    result = 0;
    do {
      b = encode.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;
    LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
    polyList.add(p);
  }
  polyLine.add(Polyline(
      polylineId: const PolylineId("1"),
      color: Colors.red,
      width: 4,
      points: polyList));
  return poly;
}

class PointLatLng {
  final double latitude;
  final double longitude;

  PointLatLng(this.latitude, this.longitude);
  @override
  String toString() {
    return "lat:$latitude / long:$longitude";
  }
}
