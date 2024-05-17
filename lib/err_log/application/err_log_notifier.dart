import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/providers.dart';
import '../infrastructures/err_log_remote_service.dart';
import '../infrastructures/err_log_repository.dart';

part 'err_log_notifier.g.dart';

@Riverpod(keepAlive: true)
ErrLogRemoteService errLogRemoteService(ErrLogRemoteServiceRef ref) {
  return ErrLogRemoteService(
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
ErrLogRepository errLogRepository(ErrLogRepositoryRef ref) {
  return ErrLogRepository(
    ref.watch(errLogRemoteServiceProvider),
  );
}

@riverpod
class ErrLogController extends _$ErrLogController {
  @override
  FutureOr<void> build() async {}

  Future<void> sendLog(
      {required String imeiDb,
      required String imeiSaved,
      required String errMessage}) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;

    final platform = Platform.isIOS ? 'iOS' : 'Android';

    state = await AsyncValue.guard(() async => await ref
        .read(errLogRepositoryProvider)
        .sendLog(
            idUser: user.idUser ?? 0,
            nama: user.nama ?? '',
            platform: platform,
            imeiDb: imeiDb,
            imeiSaved: imeiSaved,
            errMessage: errMessage));
  }
}
