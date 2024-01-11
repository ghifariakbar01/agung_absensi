import 'dart:developer';

import 'package:face_net_authentication/infrastructure/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'error_message_widget.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({required this.value, required this.data});
  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) {
        String errMessage = '';

        debugger();

        if (e is RestApiExceptionWithMessage && e.message != null) {
          errMessage = e.message!;
        } else if (e is FormatException) {
          errMessage = e.message;
        } else if (e is RestApiException) {
          errMessage = 'Error RestApiException ${e.errorCode.toString()}';
        } else {
          debugger();

          errMessage = e.toString();
        }

        return Center(child: ErrorMessageWidget(errMessage));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class VAsyncWidgetScaffold<T> extends StatelessWidget {
  const VAsyncWidgetScaffold({
    required this.value,
    required this.data,
  });
  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) => Scaffold(
        appBar: AppBar(),
        body: Center(child: ErrorMessageWidget(e.toString())),
      ),
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
