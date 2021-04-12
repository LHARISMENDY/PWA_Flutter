import 'dart:async';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:provider/provider.dart';
import 'package:pwa_flutter/services/Zxing.dart';
import 'package:pwa_flutter/theme/app_colors.dart';
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

class __ViewState extends State<_View> with SingleTickerProviderStateMixin {
  Widget _webcamWidget;
  VideoElement _webcamVideoElement;
  ImageData image;
  Timer _timer;
  AnimationController _animationController;
  Animation<double> _animation;
  Animation<int> alpha;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    )
      ..addListener(
        () => setState(() {}),
      )
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _animationController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _animationController.forward();
          }
        },
      );

    _animationController.forward();

    _webcamVideoElement = VideoElement()..autoplay = true;

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

  @override
  Widget build(BuildContext context) {
    double _scannerAnimationSize = 200;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Scan your code",
              style: AppTextStyle.title,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Place your code inside the frame to scan.\nPlease avoid shaking for best result',
                textAlign: TextAlign.center,
                style: AppTextStyle.body,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 1.5,
                    maxHeight: MediaQuery.of(context).size.height / 1.5,
                  ),
                  child: _webcamWidget,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 5,
                        left:
                            _animation.value * (_scannerAnimationSize - 10) + 3,
                        child: Container(
                          width: 4,
                          height: _scannerAnimationSize - 10,
                          color: AppColors.titleColor,
                        ),
                      ),
                      Container(
                        width: _scannerAnimationSize,
                        height: _scannerAnimationSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(2),
                          ),
                          border: Border.all(
                            width: 5,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Consumer<ScannerNotifier>(
              builder: (_, notifier, __) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Code :  ',
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
