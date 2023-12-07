import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

 class UpdateCurrentLocation extends ValueNotifier<LatLng>{
  UpdateCurrentLocation._():super(const LatLng(7.9465,1.0232));
  static final UpdateCurrentLocation _instance = UpdateCurrentLocation._();
  factory UpdateCurrentLocation()=> _instance;
  void cLocation(LatLng location){
    value = location;
    notifyListeners();
  }
}