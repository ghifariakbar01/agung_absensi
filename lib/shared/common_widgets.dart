import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../style/style.dart';

class CommonWidget {
  lottie(
    String asset,
    String message,
    AnimationController _controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/location.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward()
              ..repeat();
          },
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          'Initializing Geofence...',
          style: Themes.customColor(
            20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
