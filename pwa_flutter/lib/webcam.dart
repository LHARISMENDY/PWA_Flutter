import 'dart:async';
import 'dart:html';
import 'dart:js';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pwa_flutter/Zxing.dart';

/// A widget.
///
class WebcamDialog extends StatefulWidget {
  /// Creates a [WebcamDialog].
  const WebcamDialog({
    Key key,
    @required this.setScanResult,
  }) : super(key: key);

  final void Function(String) setScanResult;

  @override
  _WebcamDialogState createState() => _WebcamDialogState();
}

class _WebcamDialogState extends State<WebcamDialog> {
  Widget _webcamWidget;
  VideoElement _webcamVideoElement;
  ImageData image;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _webcamVideoElement = VideoElement();

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

    _webcamVideoElement.play();
  }

  @override
  void dispose() {
    _webcamVideoElement.pause();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Call the scanner
    _timer = Timer.periodic(
      Duration(milliseconds: 400),
      (timer) async => detectCode(
        _webcamVideoElement.srcObject,
        allowInterop(
          (result) {
            widget.setScanResult;
            Navigator.pop(context);
          },
        ),
      ),
    );

    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 1.5,
              maxHeight: MediaQuery.of(context).size.height / 1.5,
            ),
            child: _webcamWidget,
          ),
          Positioned(
            right: 0.0,
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                iconSize: 40,
                icon: Icon(
                  Icons.close,
                ),
                color: Colors.red,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
