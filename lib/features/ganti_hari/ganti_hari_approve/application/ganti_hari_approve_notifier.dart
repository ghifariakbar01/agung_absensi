import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../shared/providers.dart';

import '../infrastructures/ganti_hari_approve_remote_service.dart.dart';
import '../infrastructures/ganti_hari_approve_repository.dart';

part 'ganti_hari_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
GantiHariApproveRemoteService gantiHariApproveRemoteService(
    GantiHariApproveRemoteServiceRef ref) {
  return GantiHariApproveRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
GantiHariApproveRepository gantiHariApproveRepository(
    GantiHariApproveRepositoryRef ref) {
  return GantiHariApproveRepository(
    ref.watch(gantiHariApproveRemoteServiceProvider),
  );
}

@riverpod
class GantiHariApproveController extends _$GantiHariApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> approve({
    required int idDayOff,
    required String jenisApp,
    required String note,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(gantiHariApproveRepositoryProvider).approve(
            idDayOff: idDayOff,
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
    required int idDayOff,
  }) async {
    state = const AsyncLoading();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    try {
      await ref.read(gantiHariApproveRepositoryProvider).batal(
            idDayOff: idDayOff,
            username: username,
            pass: pass,
          );

      state = AsyncData<void>('Sukses Membatalkan Form Ganti Hari');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
