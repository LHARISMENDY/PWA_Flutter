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
    @required this.updateScanResult,
  }) : super(key: key);

  final Function(String) updateScanResult;

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

    Future.delayed(
      Duration(seconds: 1),
      () {
        _timer = Timer.periodic(
          Duration(
            milliseconds: 400,
          ),
          (timer) async => _takePicture(),
        );
      },
    );
  }

  void _takePicture() async {
    final _canvasElement = CanvasElement(
        width: _webcamVideoElement.width, height: _webcamVideoElement.height);
    final context = _canvasElement.context2D;
    context.drawImageScaled(
      _webcamVideoElement,
      0,
      0,
      _webcamVideoElement.width,
      _webcamVideoElement.height,
    );
    image = context.getImageData(
        0, 0, _canvasElement.width ?? 0, _canvasElement.height ?? 0);
    final dataUrl = _canvasElement.toDataUrl('image/png');
    _webcamVideoElement.src = dataUrl;

    detectCode(dataUrl, allowInterop(widget.updateScanResult));
  }

  @override
  void dispose() {
    _webcamVideoElement.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
