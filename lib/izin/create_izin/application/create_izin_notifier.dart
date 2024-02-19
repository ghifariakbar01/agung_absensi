import 'package:face_net_authentication/izin/create_izin/infrastructure/create_izin_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';
import '../../../wa_head_helper/application/wa_head.dart';
import '../../../wa_head_helper/application/wa_head_helper_notifier.dart';

import '../infrastructure/create_izin_remote_service.dart';

part 'create_izin_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateIzinRemoteService createIzinRemoteService(
    CreateIzinRemoteServiceRef ref) {
  return CreateIzinRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CreateIzinRepository createIzinRepository(CreateIzinRepositoryRef ref) {
  return CreateIzinRepository(
    ref.watch(createIzinRemoteServiceProvider),
  );
}

@riverpod
class CreateIzinNotifier extends _$CreateIzinNotifier {
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

  Future<void> submitIzin(
      {required int idUser,
      required int idMstIzin,
      required int totalHari,
      required String ket,
      required String cUser,
      required String tglAwal,
      required String tglAkhir,
      required String keterangan,
      required Future<void> Function(String errMessage) onError}) async {
    state = const AsyncLoading();

    try {
      final cUser = ref.read(userNotifierProvider).user.nama!;
      final String messageContent =
          " ( Testing Apps ) Terdapat Waiting Approve Pengajuan Izin Umum Baru Telah Diinput Oleh : $cUser ";
      await _sendWaToHead(idUser: idUser, messageContent: messageContent);

      state = await AsyncValue.guard(() => ref
          .read(createIzinRepositoryProvider)
          .submitIzin(
              idUser: idUser,
              idMstIzin: idMstIzin,
              totalHari: totalHari,
              ket: ket,
              cUser: cUser,
              tglEnd: tglAkhir,
              tglStart: tglAwal));
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<void> updateIzin(
      {
      //
      required int idIzin,
      required int idUser,
      required int idMstIzin,
      required int totalHari,
      required String ket,
      required String uUser,
      required String tglAwal,
      required String tglAkhir,
      required Future<void> Function(String errMessage) onError
      //
      }) async {
    state = const AsyncLoading();

    try {
      final uUser = ref.read(userNotifierProvider).user.nama!;

      state = await AsyncValue.guard(() => ref
          .read(createIzinRepositoryProvider)
          .updateIzin(
              id: idIzin,
              idUser: idUser,
              idMstIzin: idMstIzin,
              totalHari: totalHari,
              ket: ket,
              uUser: uUser,
              tglEnd: tglAkhir,
              tglStart: tglAwal));
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }
}
