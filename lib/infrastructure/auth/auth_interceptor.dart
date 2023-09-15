import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref);

  final Ref _ref;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    super.onResponse(response, handler);

    final items = response.data?[0];

    // // final message = items['error'] as String?;
    // final errorNum = items['errornum'] as int?;

    // PasswordExpiredState passwordExpired =
    //     _ref.read(passwordExpiredNotifierStatusProvider);
    // PasswordExpiredNotifier passwordExpiredNotifier =
    //     _ref.read(passwordExpiredNotifierProvider.notifier);

    // // SET USER
    // final userNotifier = _ref.watch(userNotifierProvider.notifier);

    // if (errorNum == null) {
    //   await passwordExpired.maybeWhen(
    //       expired: () async {
    //         await passwordExpiredNotifier.clearPasswordExpired();

    //         String userInString = await userNotifier.getUserString();
    //         final userWithPassword = userNotifier.parseUser(userInString);

    //         await userWithPassword.fold(
    //             (_) => null, (user) => userNotifier.setUser(user));
    //         await _ref
    //             .read(passwordExpiredNotifierProvider.notifier)
    //             .clearPasswordExpired();

    //         // RELOAD USER
    //         _ref.read(initUserStatusProvider.notifier).state =
    //             InitUserStatus.init();
    //         debugger();
    //       },
    //       orElse: () {});
    // }

    // if (errorNum == Constants.passWrongCode ||
    //     errorNum == Constants.passExpCode) {
    //   await passwordExpiredNotifier.savePasswordExpired();
    // }

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
