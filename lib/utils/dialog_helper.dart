import 'package:face_net_authentication/utils/os_vibrate.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';
import '../style/style.dart';
import '../widgets/v_dialogs.dart';

class DialogHelper {
  static Future<void> showErrorDialog(String msg, BuildContext context) async {
    return OSVibrate.vibrate().then((value) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              color: Palette.red,
              asset: Assets.iconCrossed,
              label: 'Oops',
              labelDescription: msg,
            )));
  }
}
