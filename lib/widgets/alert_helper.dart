import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

import '../utils/os_vibrate.dart';

class AlertHelper {
  static void showSnackBar(BuildContext context,
      {required String message,
      Color? color,
      Future<void> Function()? onDone}) {
    OSVibrate.vibrate().then((_) => showFlash(
          context: context,
          persistent: true,
          barrierDismissible: false,
          duration: const Duration(seconds: 2),
          builder: (context, controller) {
            return FlashBar(
              controller: controller,
              backgroundColor: color ?? Colors.red,
              behavior: FlashBehavior.floating,
              content: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ).then((_) => onDone != null ? onDone() : () {}));
  }
}
