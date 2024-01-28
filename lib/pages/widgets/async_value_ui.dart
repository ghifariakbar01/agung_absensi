import 'dart:developer';

import 'package:face_net_authentication/infrastructure/exceptions.dart';
import 'package:face_net_authentication/pages/widgets/alert_dialogs.dart';
import 'package:face_net_authentication/utils/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    debugPrint('isLoading: $isLoading, hasError: $hasError');
    if (!isLoading && hasError) {
      String message = '';

      log('error is $error');
      if (error is RestApiExceptionWithMessage) {
        message = (error as RestApiExceptionWithMessage).message ??
            'Error RestApiExceptionWithMessage';
      } else if (error is FormatException) {
        message = (error as FormatException).message;
      } else if (error is RestApiException) {
        message = (error as RestApiException).errorCode.toString();
      } else {
        log('error is here');

        message = error.toString();
      }

      showExceptionAlertDialog(
        context: context,
        title: 'Error'.hardcoded,
        exception: message,
      );
    }
  }
}
