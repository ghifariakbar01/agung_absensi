import 'package:face_net_authentication/utils/os_vibrate.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';
import '../widgets/v_dialogs.dart';

class DialogHelper<T> {
  static Future<void> showCustomDialog(
    String msg,
    BuildContext context, {
    Color? color,
    String? label,
    String? assets,
    bool? isLarge,
  }) async {
    return OSVibrate.vibrate().then((_) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              label: label ?? 'Oops',
              fontSize: isLarge == null ? 11 : 13,
              labelDescription: msg,
              color: color ?? Colors.white,
              asset: assets ?? Assets.iconCrossed,
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

  static Future<bool> showConfirmationDialog({
    String? label,
    required BuildContext context,
  }) async {
    await OSVibrate.vibrate();

    final bool? result = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VAlertDialog4(label: label ?? 'Oops'));

    if (result == null) {
      return false;
    }

    return result;
  }
}
