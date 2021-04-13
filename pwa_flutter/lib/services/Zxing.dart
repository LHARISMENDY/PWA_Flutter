@JS()
library zxing;

import 'dart:html';

import 'package:js/js.dart';

@JS("detectCode")
external void detectCode(
  MediaStream stream,
  CodeResultCallback callback,
);

typedef CodeResultCallback = void Function(String result);
