import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';

import '../infrastructures/izin_approve_remote_service.dart.dart';
import '../infrastructures/izin_approve_repository.dart';

part 'izin_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
IzinApproveRemoteService izinApproveRemoteService(
    IzinApproveRemoteServiceRef ref) {
  return IzinApproveRemoteService(
    ref.watch(dioProviderHosting),
  );
}

@Riverpod(keepAlive: true)
IzinApproveRepository izinApproveRepository(IzinApproveRepositoryRef ref) {
  return IzinApproveRepository(
    ref.watch(izinApproveRemoteServiceProvider),
  );
}

@riverpod
class IzinApproveController extends _$IzinApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> approve({
    required int idIzin,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = 'testing',
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(izinApproveRepositoryProvider).approve(
            idIzin: idIzin,
            username: username,
            pass: pass,
            jenisApp: jenisApp,
            note: note,
            tahun: tahun,
            server: server,
          );

      state = AsyncData<void>('Sukses');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> batal({
    required int idIzin,
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(izinApproveRepositoryProvider).batal(
            idIzin: idIzin,
            username: username,
            pass: pass,
          );

      state = AsyncData<void>('Sukses Membatalkan Form Izin');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
