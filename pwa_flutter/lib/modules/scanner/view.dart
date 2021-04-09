import 'dart:async';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:provider/provider.dart';
import 'package:pwa_flutter/services/Zxing.dart';

import 'notifier.dart';

/// A widget.
class ScannerView extends StatelessWidget {
  /// Creates a [ScannerView].
  const ScannerView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScannerNotifier>(
      create: (_) => ScannerNotifier(),
      child: const _View(),
    );
  }
}

/// A widget.
///
class _View extends StatefulWidget {
  /// Creates a [_View].
  const _View({
    Key key,
  }) : super(key: key);

  @override
  __ViewState createState() => __ViewState();
}

class __ViewState extends State<_View> {
  Widget _webcamWidget;
  VideoElement _webcamVideoElement;
  ImageData image;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _webcamVideoElement = VideoElement()..autoplay = true;

    //Find a webcam [platformViewRegistry does exist]
    ui.platformViewRegistry.registerViewFactory(
      'webcamVideoElement',
      (int viewId) => _webcamVideoElement,
    );

    //Create the video widget
    _webcamWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: 'webcamVideoElement',
    );

    //Access the webcam Stream
    window.navigator
        .getUserMedia(
      video: true,
    )
        .then(
      (MediaStream stream) {
        _webcamVideoElement.srcObject = stream;
      },
    );

    //Call the scanner
    _timer = Timer.periodic(
      Duration(milliseconds: 400),
      (timer) async => detectCode(
        _webcamVideoElement.srcObject,
        allowInterop(
          (result) => context.read<ScannerNotifier>().scanResult = result,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _webcamVideoElement.pause();
    _timer.cancel();
    _webcamVideoElement.srcObject.getTracks().forEach((track) {
      track.stop();
      track.enabled = false;
    });
    _webcamVideoElement.srcObject = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.5,
                maxHeight: MediaQuery.of(context).size.height / 1.5,
              ),
              child: _webcamWidget,
            ),
          ),
          Consumer<ScannerNotifier>(
            builder: (_, notifier, __) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Code : ${notifier.scanResult}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
