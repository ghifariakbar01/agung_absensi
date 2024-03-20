import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';
import '../../../wa_head_helper/application/wa_head.dart';
import '../../../wa_head_helper/application/wa_head_helper_notifier.dart';
import '../infrastructure/create_ganti_hari_remote_service.dart';
import '../infrastructure/create_ganti_hari_repository.dart';
import 'absen_ganti_hari.dart';

part 'create_ganti_hari_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateGantiHariRemoteService createGantiHariRemoteService(
    CreateGantiHariRemoteServiceRef ref) {
  return CreateGantiHariRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CreateGantiHariRepository createGantiHariRepository(
    CreateGantiHariRepositoryRef ref) {
  return CreateGantiHariRepository(
    ref.watch(createGantiHariRemoteServiceProvider),
  );
}

@riverpod
class AbsenGantiHariNotifier extends _$AbsenGantiHariNotifier {
  @override
  FutureOr<List<AbsenGantiHari>> build() async {
    return ref.read(createGantiHariRepositoryProvider).getAbsenGantiHari();
  }
}

@riverpod
class CreateGantiHari extends _$CreateGantiHari {
  @override
  FutureOr<void> build() async {}

  Future<void> _sendWaToHead(
      {required int idUser, required String messageContent}) async {
    final List<WaHead> waHeads = await ref
        .read(waHeadHelperNotifierProvider.notifier)
        .getWaHeads(idUser: idUser);

    if (waHeads.isNotEmpty) {
      for (int i = 0; i < waHeads.length; i++) {
        if (waHeads[i].telp1 != null) {
          if (waHeads[i].telp1!.isNotEmpty)
            await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
                phone: int.parse(waHeads[i].telp1!),
                idUser: waHeads[i].idUserHead!,
                idDept: waHeads[i].idDept!,
                notifTitle: 'Notifikasi HRMS',
                notifContent: '$messageContent');
        } else if (waHeads[i].telp2 != null) {
          if (waHeads[i].telp2!.isNotEmpty)
            await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
                phone: int.parse(waHeads[i].telp2!),
                idUser: waHeads[i].idUserHead!,
                idDept: waHeads[i].idDept!,
                notifTitle: 'Notifikasi HRMS',
                notifContent: '$messageContent');
        } else {
          throw AssertionError(
              'Atasan bernama ${waHeads[i].nama} tidak memiliki data nomor Hp...');
        }
      }
    } else {
      //
      throw AssertionError('User tidak memiliki data atasan...');
    }
  }

  Future<void> submitGantiHari(
      {required int idUser,
      required int idAbsen,
      required String ket,
      required String tglOff,
      required String tglGanti,
      required String cUser,
      required Future<void> Function(String errMessage) onError}) async {
    state = const AsyncLoading();

    try {
      final String messageContent =
          " ( Testing Apps ) Terdapat Waiting Approve Pengajuan Ganti Hari Umum Baru Telah Diinput Oleh : $cUser ";
      await _sendWaToHead(idUser: idUser, messageContent: messageContent);

      state = await AsyncValue.guard(
          () => ref.read(createGantiHariRepositoryProvider).submitGantiHari(
                idUser: idUser,
                idAbsen: idAbsen,
                ket: ket,
                tglOff: tglOff,
                tglGanti: tglGanti,
                cUser: cUser,
              ));
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<void> updateGantiHari(
      {required int id,
      required int idAbsen,
      required String ket,
      required String tglOff,
      required String tglGanti,
      required String uUser,
      required Future<void> Function(String errMessage) onError}) async {
    state = const AsyncLoading();

    try {
      state = await AsyncValue.guard(
          () => ref.read(createGantiHariRepositoryProvider).updateGantiHari(
                id: id,
                idAbsen: idAbsen,
                ket: ket,
                tglOff: tglOff,
                tglGanti: tglGanti,
                uUser: uUser,
              ));
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }
}
