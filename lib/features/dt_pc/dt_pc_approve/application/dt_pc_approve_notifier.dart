import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../shared/providers.dart';

import '../infrastructures/dt_pc_approve_remote_service.dart.dart';
import '../infrastructures/dt_pc_approve_repository.dart';

part 'dt_pc_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
DtPcApproveRemoteService dtPcApproveRemoteService(
    DtPcApproveRemoteServiceRef ref) {
  return DtPcApproveRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
DtPcApproveRepository dtPcApproveRepository(DtPcApproveRepositoryRef ref) {
  return DtPcApproveRepository(
    ref.watch(dtPcApproveRemoteServiceProvider),
  );
}

@riverpod
class DtPcApproveController extends _$DtPcApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> approve({
    required int idDt,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(dtPcApproveRepositoryProvider).approve(
            idDt: idDt,
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
    required int idDt,
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(dtPcApproveRepositoryProvider).batal(
            idDt: idDt,
            username: username,
            pass: pass,
          );

      state = AsyncData<void>('Sukses Membatalkan Form Dt / Pc');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
