@JS()
library zxing;

import 'package:js/js.dart';

@JS("detectCode")
external void detectCode(
  String dataUrl,
  CodeResultCallback callback,
);

typedef CodeResultCallback = void Function(String result);
