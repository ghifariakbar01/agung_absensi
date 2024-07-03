import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/providers.dart';
import '../infrastructures/err_log_remote_service.dart';
import '../infrastructures/err_log_repository.dart';

part 'err_log_notifier.g.dart';

@Riverpod(keepAlive: true)
ErrLogRemoteService errLogRemoteService(ErrLogRemoteServiceRef ref) {
  return ErrLogRemoteService(
    ref.watch(dioProvider),
    ref.watch(dioRequestProvider),
  );
}

@Riverpod(keepAlive: true)
ErrLogRemoteService errLogRemoteServiceHosting(ErrLogRemoteServiceRef ref) {
  return ErrLogRemoteService(
    ref.watch(dioProviderHosting),
    ref.watch(dioRequestProvider),
  );
}

@Riverpod(keepAlive: true)
ErrLogRepository errLogRepository(ErrLogRepositoryRef ref) {
  return ErrLogRepository(
    ref.watch(errLogRemoteServiceProvider),
  );
}

@Riverpod(keepAlive: true)
ErrLogRepository errLogRepositoryHosting(ErrLogRepositoryRef ref) {
  return ErrLogRepository(
    ref.watch(errLogRemoteServiceHostingProvider),
  );
}

@riverpod
class ErrLogController extends _$ErrLogController {
  @override
  FutureOr<void> build() async {}

  Future<void> sendLog({
    bool? isHoting,
    String? imeiDb,
    String? imeiSaved,
    required String errMessage,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;

    final _imei = ref.read(imeiNotifierProvider.notifier);

    final _saved = user.imeiHp ?? '-';
    final _db =
        imeiDb ?? await _imei.getImeiStringDb(idKary: user.IdKary ?? '-');

    final platform = Platform.isIOS ? 'iOS' : 'Android';

    state = await AsyncValue.guard(() async {
      if (isHoting != null) {
        await ref.read(errLogRepositoryHostingProvider).sendLog(
              idUser: user.idUser ?? 0,
              nama: user.nama ?? '',
              platform: platform,
              imeiDb: _db,
              imeiSaved: _saved,
              errMessage: errMessage,
            );
      }

      await ref.read(errLogRepositoryProvider).sendLog(
            idUser: user.idUser ?? 0,
            nama: user.nama ?? '',
            platform: platform,
            imeiDb: _db,
            imeiSaved: _saved,
            errMessage: errMessage,
          );

      return;
    });
  }
}
