import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../shared/providers.dart';

import '../infrastructures/cuti_approve_remote_service.dart.dart';
import '../infrastructures/cuti_approve_repository.dart';

part 'cuti_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
CutiApproveRemoteService cutiApproveRemoteService(
    CutiApproveRemoteServiceRef ref) {
  return CutiApproveRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
CutiApproveRepository cutiApproveRepository(CutiApproveRepositoryRef ref) {
  return CutiApproveRepository(
    ref.watch(cutiApproveRemoteServiceProvider),
  );
}

@riverpod
class CutiApproveController extends _$CutiApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> approve({
    required int idCuti,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(cutiApproveRepositoryProvider).approve(
            idCuti: idCuti,
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
    required int idCuti,
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(cutiApproveRepositoryProvider).batal(
            idCuti: idCuti,
            username: username,
            pass: pass,
          );

      state = AsyncData<void>('Sukses Membatalkan Form Cuti');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
