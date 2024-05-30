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

    if (items['status_code'] == 200) {
      _ref.read(absenOfflineModeProvider.notifier).state = false;
    }
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    super.onError(e, handler);

    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      _ref.read(absenOfflineModeProvider.notifier).state = true;
    }
  }
}
