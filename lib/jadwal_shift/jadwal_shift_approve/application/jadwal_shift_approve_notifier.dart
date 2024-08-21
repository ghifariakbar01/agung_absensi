import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/constants.dart';
import '../../../shared/providers.dart';

import '../infrastructures/jadwal_shift_approve_remote_service.dart.dart';
import '../infrastructures/jadwal_shift_approve_repository.dart';

part 'jadwal_shift_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
JadwalShiftApproveRemoteService jadwalShiftApproveRemoteService(
    JadwalShiftApproveRemoteServiceRef ref) {
  return JadwalShiftApproveRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
JadwalShiftApproveRepository jadwalShiftApproveRepository(
    JadwalShiftApproveRepositoryRef ref) {
  return JadwalShiftApproveRepository(
    ref.watch(jadwalShiftApproveRemoteServiceProvider),
  );
}

@riverpod
class JadwalShiftApproveController extends _$JadwalShiftApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> approve({
    required int idShift,
    required String jenisApp,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(jadwalShiftApproveRepositoryProvider).approve(
            idShift: idShift,
            username: username,
            pass: pass,
            jenisApp: jenisApp,
            server: server,
          );

      state = AsyncData<void>('Sukses');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> batal({
    required int idShift,
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(jadwalShiftApproveRepositoryProvider).batal(
            idShift: idShift,
            username: username,
            pass: pass,
          );

      state = AsyncData<void>('Sukses Membatalkan Form Jadwal Shift');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
