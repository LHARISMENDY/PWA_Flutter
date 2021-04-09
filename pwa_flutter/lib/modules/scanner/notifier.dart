import 'package:flutter/cupertino.dart';

class ScannerNotifier extends ChangeNotifier {
  String _scanResult = '';
  String get scanResult => _scanResult;
  set scanResult(String value) {
    if (_scanResult != value) {
      _scanResult = value;
      notifyListeners();
    }
  }
}
