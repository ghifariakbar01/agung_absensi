import 'package:face_net_authentication/utils/os_vibrate.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';
import '../style/style.dart';
import '../widgets/v_dialogs.dart';

class DialogHelper<T> {
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

  Future<String?> showFormDialog({
    String? label,
    required BuildContext context,
  }) async {
    TextEditingController? formController;

    formController = TextEditingController();

    final String? result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => VFormDialog(
        label: label ?? 'Note HRD',
        formController: formController!,
      ),
    );

    formController = null;
    if (result != null) {
      return result;
    }

    return null;
  }
}
