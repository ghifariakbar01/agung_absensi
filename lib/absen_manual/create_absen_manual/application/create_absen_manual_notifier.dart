// ignore_for_file: sdk_version_since

import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';
import '../../../utils/string_utils.dart';
import '../../../wa_head_helper/application/wa_head.dart';
import '../../../wa_head_helper/application/wa_head_helper_notifier.dart';

import '../infrastructure/create_absen_manual_remote_service.dart';
import '../infrastructure/create_absen_manual_repository.dart';
import 'jenis_absen.dart';

part 'create_absen_manual_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateAbsenManualRemoteService createAbsenManualRemoteService(
    CreateAbsenManualRemoteServiceRef ref) {
  return CreateAbsenManualRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CreateAbsenManualRepository createAbsenManualRepository(
    CreateAbsenManualRepositoryRef ref) {
  return CreateAbsenManualRepository(
    ref.watch(createAbsenManualRemoteServiceProvider),
  );
}

@riverpod
class JenisAbsenManualNotifier extends _$JenisAbsenManualNotifier {
  @override
  FutureOr<List<JenisAbsen>> build() async {
    return ref.read(createAbsenManualRepositoryProvider).getJenisAbsen();
  }
}

@riverpod
class CreateAbsenManualNotifier extends _$CreateAbsenManualNotifier {
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

  Future<void> submitAbsenManual(
      {
      //
      required int idUser,
      required String ket,
      required String tgl,
      required String jamAwal,
      required String jamAkhir,
      required String jenisAbsen,
      required String cUser,
      required Future<void> Function(String errMessage) onError}) async {
    state = const AsyncLoading();

    try {
      debugger();

      // final cUser = ref.read(userNotifierProvider).user.nama!;
      // final String messageContent =
      //     " ( Testing Apps ) Terdapat Waiting Aprove Pengajuan Absen Manual Baru Telah Diinput Oleh : $cUser ";
      // await _sendWaToHead(idUser: idUser, messageContent: messageContent);

      if (jenisAbsen.toLowerCase() == 'lln') {
        state = await AsyncValue.guard(() =>
            ref.read(createAbsenManualRepositoryProvider).submitAbsenManual(
                  idUser: idUser,
                  ket: ket,
                  tgl: tgl,
                  jamAwal: jamAwal,
                  jamAkhir: jamAkhir,
                  jenisAbsen: jenisAbsen,
                  cUser: cUser,
                ));
      } else {
        final String tglFinal =
            StringUtils.midnightDate(DateTime.now()).replaceAll('.000', '');

        final jamAwalDate = DateTime.parse(jamAwal);
        final jamAwalDateFinal = DateTime.now()
            .copyWith(hour: jamAwalDate.hour, minute: jamAwalDate.minute);
        final String jamAwalFinal = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(jamAwalDateFinal).toString();

        final jamAkhirDate = DateTime.parse(jamAkhir);
        final jamAkhirDateFinal = DateTime.now()
            .copyWith(hour: jamAkhirDate.hour, minute: jamAkhirDate.minute);
        final String jamAkhirFinal = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(jamAkhirDateFinal).toString();

        log('tglFinal $tglFinal');
        log('jamAwalFinal $jamAwalFinal');
        log('jamAkhirFinal $jamAkhirFinal');

        state = await AsyncValue.guard(() =>
            ref.read(createAbsenManualRepositoryProvider).submitAbsenManual(
                  idUser: idUser,
                  ket: ket,
                  tgl: tglFinal,
                  jamAwal: jamAwalFinal,
                  jamAkhir: jamAkhirFinal,
                  jenisAbsen: jenisAbsen,
                  cUser: cUser,
                ));
      }
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<void> updateAbsenManual(
      {
      //
      required int id,
      required int idUser,
      required String ket,
      required String tgl,
      required String jamAwal,
      required String jamAkhir,
      required String jenisAbsen,
      required String uUser,
      required Future<void> Function(String errMessage) onError}) async {
    state = const AsyncLoading();

    try {
      final jamAwalDateTime = DateTime.parse(jamAwal);
      final jamAkhirDateTime = DateTime.parse(jamAkhir);

      if (jamAkhirDateTime.difference(jamAwalDateTime).inDays > 1) {
        throw AssertionError('Tanggal input lewat dari 1 hari');
      }

      state = await AsyncValue.guard(
          () => ref.read(createAbsenManualRepositoryProvider).updateAbsenManual(
                id: id,
                idUser: idUser,
                ket: ket,
                tgl: tgl,
                jamAwal: jamAwal,
                jamAkhir: jamAkhir,
                jenisAbsen: jenisAbsen,
                uUser: uUser,
              ));
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }
}
