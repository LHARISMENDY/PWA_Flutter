import 'dart:async';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:provider/provider.dart';
import 'package:pwa_flutter/core/widget/scanner_widget.dart';
import 'package:pwa_flutter/services/Zxing.dart';
import 'package:pwa_flutter/theme/app_text_style.dart';

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

class __ViewState extends State<_View> with TickerProviderStateMixin {
  Widget _webcamWidget;
  VideoElement _webcamVideoElement;
  ImageData image;
  Timer _timer;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _webcamVideoElement = VideoElement()..autoplay = true;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animateScanAnimation(true);
        } else if (status == AnimationStatus.dismissed) {
          animateScanAnimation(false);
        }
      });

    //Find a webcam [platformViewRegistry does exist]
    //// ignore: undefined_prefixed_name
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
    if (window.location.protocol.contains('https')) {
      var options;
      if (window.navigator.userAgent.contains('Mobi')) {
        options = {
          'video': {
            'facingMode': {'exact': 'environment'}
          }
        };
      } else {
        options = {'video': true};
      }
      window.navigator.mediaDevices.getUserMedia(options).then(
        (MediaStream stream) {
          _webcamVideoElement.srcObject = stream;
        },
      );
    } else {
      window.navigator.getUserMedia(video: true).then(
        (MediaStream stream) {
          _webcamVideoElement.srcObject = stream;
        },
      );
    }

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

    animateScanAnimation(true);
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

    _animationController.dispose();
    super.dispose();
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 1.5,
                    maxHeight: MediaQuery.of(context).size.height / 1.5,
                  ),
                  child: _webcamWidget,
                ),
                ImageScannerAnimation(
                  false,
                  MediaQuery.of(context).size.height / 1.5,
                  animation: _animationController,
                ),
              ],
            ),
            Consumer<ScannerNotifier>(
              builder: (_, notifier, __) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Code :',
                    style: AppTextStyle.title,
                    children: [
                      TextSpan(
                        text: '${notifier.scanResult}',
                        style: AppTextStyle.body,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
