import 'package:flutter/material.dart';
import 'package:pwa_flutter/theme/app_colors.dart';

class ImageScannerAnimation extends AnimatedWidget {
  final bool stopped;
  final double height;

  ImageScannerAnimation(
    this.stopped,
    this.height, {
    Key key,
    Animation<double> animation,
  }) : super(
          key: key,
          listenable: animation,
        );

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    final scorePosition = (animation.value * 440) + 16;

    Color color1 = AppColors.primaryColor;
    Color color2 = AppColors.primaryColor.withOpacity(0.01);

    if (animation.status == AnimationStatus.reverse) {
      color1 = AppColors.primaryColor.withOpacity(0.01);
      color2 = AppColors.primaryColor;
    }

    return new Positioned(
      right: scorePosition,
      child: new Opacity(
        opacity: (stopped) ? 0.0 : 1.0,
        child: Container(
          height: height,
          width: 10,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.1, 0.9],
              colors: [color1, color2],
            ),
          ),
        ),
      ),
    );
  }
}
