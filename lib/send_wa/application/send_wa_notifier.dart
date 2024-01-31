import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';

import '../infrastructure/send_wa_remote_service.dart';
import '../infrastructure/send_wa_repository.dart';

part 'send_wa_notifier.g.dart';

@Riverpod(keepAlive: true)
SendWaRemoteService sendWaRemoteService(SendWaRemoteServiceRef ref) {
  return SendWaRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
SendWaRepository sendWaRepository(SendWaRepositoryRef ref) {
  return SendWaRepository(
    ref.watch(sendWaRemoteServiceProvider),
  );
}

@riverpod
class SendWaNotifier extends _$SendWaNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> sendWa(
      {
      //
      required int phone,
      required int idUser,
      required int idDept,
      required String notifTitle,
      required String notifContent
      //
      }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard<Unit>(() async {
      return ref.read(sendWaRepositoryProvider).sendWa(
          phone: phone,
          idUser: idUser,
          idDept: idDept,
          notifTitle: notifTitle,
          notifContent: notifContent);
    });
  }
}
