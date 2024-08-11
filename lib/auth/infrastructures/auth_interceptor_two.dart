import 'package:dio/dio.dart';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthInterceptorTwo extends Interceptor {
  AuthInterceptorTwo(this._ref);

  final Ref _ref;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    super.onResponse(response, handler);

    final items = response.data;

    if (items == null) {
      _ref.read(absenOfflineModeProvider.notifier).state = true;
      throw DioException.connectionTimeout(
          requestOptions: response.requestOptions,
          timeout: Duration(
            seconds: 10,
          ));
    }

    if (response.statusCode == 200) {
      _ref.read(absenOfflineModeProvider.notifier).state = false;
    }

    if (response.statusCode != 200) {
      _ref.read(absenOfflineModeProvider.notifier).state = true;
      throw DioException.connectionTimeout(
          requestOptions: response.requestOptions,
          timeout: Duration(
            seconds: 10,
          ));
    }

    final errorNum = items['errornum'] as int?;
    if (errorNum == 1) {
      _ref.read(absenOfflineModeProvider.notifier).state = true;
      throw DioException.connectionTimeout(
          requestOptions: response.requestOptions,
          timeout: Duration(
            seconds: 10,
          ));
    }
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    super.onError(e, handler);

    if (e.response == null) {
      _ref.read(absenOfflineModeProvider.notifier).state = true;
    }

    if (e.response!.statusCode != 200) {
      _ref.read(absenOfflineModeProvider.notifier).state = true;
    }

    if (e.type == DioExceptionType.unknown ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      _ref.read(absenOfflineModeProvider.notifier).state = true;
    }
  }
}
