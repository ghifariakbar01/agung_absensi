import 'dart:io';

import 'package:flutter/services.dart';

class OSVibrate {
  static Future<void> vibrate() async => Platform.isIOS
      ? await HapticFeedback.lightImpact()
      : await HapticFeedback.vibrate();
}
