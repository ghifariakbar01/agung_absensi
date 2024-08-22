import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../../cross_auth/application/cross_auth_notifier.dart';
import '../infrastructures/mst_karyawan_cuti_remote_service.dart';
import '../infrastructures/mst_karyawan_cuti_repository.dart';
import 'mst_karyawan_cuti.dart';

part 'mst_karyawan_cuti_notifier.g.dart';

@Riverpod(keepAlive: true)
MstKaryawanCutiRemoteService mstKaryawanCutiRemoteService(
    MstKaryawanCutiRemoteServiceRef ref) {
  return MstKaryawanCutiRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
MstKaryawanCutiRepository mstKaryawanCutiRepository(
    MstKaryawanCutiRepositoryRef ref) {
  return MstKaryawanCutiRepository(
    ref.watch(mstKaryawanCutiRemoteServiceProvider),
  );
}

@riverpod
class MstKaryawanCutiNotifier extends _$MstKaryawanCutiNotifier {
  @override
  FutureOr<MstKaryawanCuti> build() async {
    final _isUserCrossed = await ref.read(isUserCrossedProvider.future);

    return _isUserCrossed.when(
      notCrossed: () async {
        final idUser = ref.read(userNotifierProvider).user.idUser;

        return await ref
            .read(mstKaryawanCutiRepositoryProvider)
            .getSaldoMasterCuti(idUser: idUser!);
      },
      crossed: MstKaryawanCuti.crossed,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final idUser = ref.read(userNotifierProvider).user.idUser;

      return ref
          .read(mstKaryawanCutiRepositoryProvider)
          .getSaldoMasterCuti(idUser: idUser!);
    });
  }
}
