import 'package:face_net_authentication/mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import 'package:face_net_authentication/mst_karyawan_cuti/infrastructure/mst_karyawan_cuti_remote_service.dart';
import 'package:face_net_authentication/mst_karyawan_cuti/infrastructure/mst_karyawan_cuti_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/providers.dart';

part 'mst_karyawan_cuti_notifier.g.dart';

@Riverpod(keepAlive: true)
MstKaryawanCutiRemoteService mstKaryawanCutiRemoteService(
    MstKaryawanCutiRemoteServiceRef ref) {
  return MstKaryawanCutiRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
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
    final idUser = ref.read(userNotifierProvider).user.idUser;

    return await ref
        .read(mstKaryawanCutiRepositoryProvider)
        .getSaldoMasterCuti(idUser: idUser!);
  }

  Future<MstKaryawanCuti> getSaldoMasterCutiById(int idUser) {
    return ref
        .read(mstKaryawanCutiRepositoryProvider)
        .getSaldoMasterCuti(idUser: idUser);
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
