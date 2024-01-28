import 'dart:developer';

import 'package:face_net_authentication/infrastructure/exceptions.dart';
import 'package:face_net_authentication/pages/widgets/v_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'error_message_widget.dart';

class VAsyncWidgetScaffold<T> extends StatelessWidget {
  const VAsyncWidgetScaffold({required this.value, required this.data});
  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) {
        String errMessage = '';

        if (e is RestApiExceptionWithMessage && e.message != null) {
          errMessage = e.message!;
        } else if (e is FormatException) {
          errMessage = e.message;
        } else if (e is RestApiException) {
          errMessage = 'Error RestApiException ${e.errorCode.toString()}';
        } else {
          errMessage = e.toString();
        }

        log('errMessage is $e');

        return Center(child: ErrorMessageWidget(errMessage));
      },
      loading: () => VScaffoldWidget(
        scaffoldTitle: 'Loading ...',
        scaffoldBody: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
