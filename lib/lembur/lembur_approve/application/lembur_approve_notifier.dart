import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/constants.dart';
import '../../../shared/providers.dart';

import '../infrastructures/lembur_approve_remote_service.dart';
import '../infrastructures/lembur_approve_repository.dart';

part 'lembur_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
LemburApproveRemoteService lemburApproveRemoteService(
    LemburApproveRemoteServiceRef ref) {
  return LemburApproveRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
LemburApproveRepository lemburApproveRepository(
    LemburApproveRepositoryRef ref) {
  return LemburApproveRepository(
    ref.watch(lemburApproveRemoteServiceProvider),
  );
}

@riverpod
class LemburApproveController extends _$LemburApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> approve({
    required int idLembur,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(lemburApproveRepositoryProvider).approve(
            idLembur: idLembur,
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
    required int idLembur,
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(lemburApproveRepositoryProvider).batal(
            idLembur: idLembur,
            username: username,
            pass: pass,
          );

      state = AsyncData<void>('Sukses Membatalkan Form Lembur');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
