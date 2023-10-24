import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _uid;

  String? get uid => _uid;

  void setUserId(String uid) {
    _uid = uid;
    notifyListeners();
  }

  void resetUserId() {
    _uid = null;
    notifyListeners();
  }
}