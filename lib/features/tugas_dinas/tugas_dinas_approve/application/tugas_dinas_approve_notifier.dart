import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../shared/providers.dart';
import '../infrastructures/tugas_dinas_approve_remote_service.dart.dart';
import '../infrastructures/tugas_dinas_approve_repository.dart';

part 'tugas_dinas_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
TugasDinasApproveRemoteService tugasDinasApproveRemoteService(
    TugasDinasApproveRemoteServiceRef ref) {
  return TugasDinasApproveRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
TugasDinasApproveRepository tugasDinasApproveRepository(
    TugasDinasApproveRepositoryRef ref) {
  return TugasDinasApproveRepository(
    ref.watch(tugasDinasApproveRemoteServiceProvider),
  );
}

@riverpod
class TugasDinasApproveController extends _$TugasDinasApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> approve({
    required int idDinas,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(tugasDinasApproveRepositoryProvider).approve(
            idDinas: idDinas,
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
    required int idDinas,
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(tugasDinasApproveRepositoryProvider).batal(
            idDinas: idDinas,
            username: username,
            pass: pass,
          );

      state = AsyncData<void>('Sukses Membatalkan Form Tugas Dinas');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
