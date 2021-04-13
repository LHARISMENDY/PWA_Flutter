@JS()
library zxing;

import 'dart:html';

import 'package:js/js.dart';

@JS("detectCode")
external Future<void> detectCode(
  String deviceId,
  CodeResultCallback callback,
);

typedef CodeResultCallback = void Function(String result);
