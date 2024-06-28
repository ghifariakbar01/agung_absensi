import 'package:face_net_authentication/infrastructures/exceptions.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../shared/common_widgets.dart';
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
          errMessage = 'Error Kode :${e.errorCode} Message: ${e.message!}';
        } else if (e is RestApiException) {
          errMessage = 'Error RestApiException ${e.errorCode.toString()}';
        } else if (e is FormatException) {
          errMessage = e.message;
        } else {
          errMessage = e.toString();
        }

        return Center(child: ErrorMessageWidget(errorMessage: errMessage));
      },
      loading: () => VScaffoldWidget(
        isLoading: true,
        scaffoldTitle: 'Loading ...',
        scaffoldBody: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class VAsyncWidgetScaffoldWrappedMaterial<T> extends HookWidget {
  const VAsyncWidgetScaffoldWrappedMaterial({
    required this.value,
    required this.data,
  });
  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    final _controller = useAnimationController();

    return value.when(
      data: data,
      error: (e, st) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(),
          body: Center(child: ErrorMessageWidget(errorMessage: e.toString())),
        ),
      ),
      loading: () => Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: CommonWidget().lottie(
            'assets/network.json',
            'Fetching url...',
            _controller,
          ),
        ),
      ),
    );
  }
}

class VAsyncValueWidget<T> extends StatelessWidget {
  const VAsyncValueWidget({required this.value, required this.data});
  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) =>
          Center(child: ErrorMessageWidget(errorMessage: e.toString())),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
