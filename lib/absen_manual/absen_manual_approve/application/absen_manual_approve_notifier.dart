import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/constants.dart';
import '../../../shared/providers.dart';

import '../infrastructures/absen_manual_approve_remote_service.dart.dart';
import '../infrastructures/absen_manual_approve_repository.dart';

part 'absen_manual_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
AbsenManualApproveRemoteService absenManualApproveRemoteService(
    AbsenManualApproveRemoteServiceRef ref) {
  return AbsenManualApproveRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
AbsenManualApproveRepository absenManualApproveRepository(
    AbsenManualApproveRepositoryRef ref) {
  return AbsenManualApproveRepository(
    ref.watch(absenManualApproveRemoteServiceProvider),
  );
}

@riverpod
class AbsenManualApproveController extends _$AbsenManualApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> approve({
    required int idAbsenMnl,
    required String jenisApp,
    required String note,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(absenManualApproveRepositoryProvider).approve(
            idAbsenMnl: idAbsenMnl,
            username: username,
            pass: pass,
            jenisApp: jenisApp,
            note: note,
            server: server,
          );

      state = AsyncData<void>('Sukses');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> batal({
    required int idAbsenMnl,
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(absenManualApproveRepositoryProvider).batal(
            idAbsenMnl: idAbsenMnl,
            username: username,
            pass: pass,
          );

      state = AsyncData<void>('Sukses Membatalkan Form Absen Manual');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
