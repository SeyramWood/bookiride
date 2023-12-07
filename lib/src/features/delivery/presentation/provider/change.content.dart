import 'package:flutter/material.dart';

class OutgoingOrDelivered extends ValueNotifier<bool> {
  OutgoingOrDelivered._sharedInference() : super(true);
  static final OutgoingOrDelivered _shared = OutgoingOrDelivered._sharedInference();
  factory OutgoingOrDelivered() => _shared;
  bool get clicked => value;
  void isClicked(bool clicked) {
    value = clicked;
    notifyListeners();
  }
}
