import 'package:face_net_authentication/utils/logging.dart';

import 'package:face_net_authentication/err_log/application/err_log_notifier.dart';
import 'package:face_net_authentication/infrastructures/exceptions.dart';
import 'package:face_net_authentication/widgets/alert_dialogs.dart';
import 'package:face_net_authentication/utils/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/providers.dart';

extension AsyncValueUI on AsyncValue {
  Future<void> showAlertDialogOnError(
      BuildContext context, WidgetRef ref) async {
    Log.info('isLoading: $isLoading, hasError: $hasError');
    if (!isLoading && hasError) {
      String message = '';

      Log.info('error is $error');
      if (error is RestApiExceptionWithMessage) {
        message = (error as RestApiExceptionWithMessage).message ??
            'Error RestApiExceptionWithMessage';
      } else if (error is FormatException) {
        message = (error as FormatException).message;
      } else if (error is RestApiException) {
        message = (error as RestApiException).errorCode.toString();
      } else {
        Log.info('error is here');

        message = error.toString();
      }

      if (error is NoConnectionException == false) {
        await _sendLog(ref, message);
      }

      return showExceptionAlertDialog(
        context: context,
        title: 'Error'.hardcoded,
        exception: message,
      );
    }
  }
}

Future<void> _sendLog(WidgetRef ref, String message) async {
  final imeiNotifier = ref.read(imeiNotifierProvider.notifier);
  final user = ref.read(userNotifierProvider).user;

  final String imeiDb = await imeiNotifier.getImeiStringDb(
    idKary: user.IdKary ?? 'IdKary null or no internet',
  );
  final String imei = await imeiNotifier.getImeiString();

  await ref.read(errLogControllerProvider.notifier).sendLog(
        imeiDb: imeiDb,
        imeiSaved: imei,
        errMessage: message,
      );
}
