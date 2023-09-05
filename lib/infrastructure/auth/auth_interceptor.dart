
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref);

  final Ref _ref;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);

    final items = response.data?[0];

    if (items != null) {
      _ref.read(absenOfflineModeProvider.notifier).state = false;
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);

    if (err.isNoConnectionError || err.isConnectionTimeout) {
      _ref.read(absenOfflineModeProvider.notifier).state = true;
    }
  }
}
