import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/constants.dart';
import '../../../shared/providers.dart';

import '../infrastructures/sakit_approve_remote_service.dart.dart';
import '../infrastructures/sakit_approve_repository.dart';

part 'sakit_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
SakitApproveRemoteService sakitApproveRemoteService(
    SakitApproveRemoteServiceRef ref) {
  return SakitApproveRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
SakitApproveRepository sakitApproveRepository(SakitApproveRepositoryRef ref) {
  return SakitApproveRepository(
    ref.watch(sakitApproveRemoteServiceProvider),
  );
}

@riverpod
class SakitApproveController extends _$SakitApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> approve({
    required int idSakit,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(sakitApproveRepositoryProvider).approve(
            idSakit: idSakit,
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
    required int idSakit,
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(sakitApproveRepositoryProvider).batal(
            idSakit: idSakit,
            username: username,
            pass: pass,
          );

      state = AsyncData<void>('Sukses Membatalkan Form Sakit');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
