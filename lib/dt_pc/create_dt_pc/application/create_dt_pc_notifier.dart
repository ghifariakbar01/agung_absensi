import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../sakit/create_sakit/application/create_sakit.dart';
import '../../../sakit/create_sakit/application/create_sakit_notifier.dart';
import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';
import '../../../utils/string_utils.dart';
import '../../../wa_head_helper/application/wa_head.dart';
import '../../../wa_head_helper/application/wa_head_helper_notifier.dart';

import '../infrastructure/create_dt_pc_remote_service.dart';
import '../infrastructure/create_dt_pc_repository.dart';

part 'create_dt_pc_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateDtPcRemoteService createDtPcRemoteService(
    CreateDtPcRemoteServiceRef ref) {
  return CreateDtPcRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CreateDtPcRepository createDtPcRepository(CreateDtPcRepositoryRef ref) {
  return CreateDtPcRepository(
    ref.watch(createDtPcRemoteServiceProvider),
  );
}

@riverpod
class CreateDtPcNotifier extends _$CreateDtPcNotifier {
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

  Future<void> submitDtPc(
      {required int idUser,
      required String ket,
      required String dtTgl,
      required String jam,
      required String kategori,
      required String cUser,
      required Future<void> Function(String errMessage) onError}) async {
    state = const AsyncLoading();

    try {
      debugger();

      final CreateSakit create = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(
              idUser,
              StringUtils.midnightDate(DateTime.parse(dtTgl))
                  .replaceAll('.000', ''),
              StringUtils.midnightDate(DateTime.now())
                  .toString()
                  .replaceAll('.000', ''));

      // 1. Calc jumlah harito substract sundays and saturdays
      final int jumlahhari =
          _getJumlahHari(create, DateTime.parse(dtTgl), DateTime.now());

      _validateJmlHariSubmit(
        jumlahhari: jumlahhari,
        kategori: kategori,
        tglAwalInDateTime: DateTime.parse(dtTgl),
        tglAkhirInDateTime: DateTime.now(),
      );

      state = await AsyncValue.guard(() async {
        await ref.read(createDtPcRepositoryProvider).submitDtPc(
              idUser: idUser,
              ket: ket,
              dtTgl: dtTgl,
              jam: jam,
              kategori: kategori,
              cUser: cUser,
            );

        final String messageContent =
            " ( Testing Apps ) Terdapat Waiting Approve Pengajuan DT/PC Baru Telah Diinput Oleh : $cUser ";
        await _sendWaToHead(idUser: idUser, messageContent: messageContent);

        return Future.value(unit);
      });
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<void> updateDtPc(
      {
      //
      required int id,
      required int idUser,
      required String ket,
      required String dtTgl,
      required String jam,
      required String kategori,
      required String uUser,
      required Future<void> Function(String errMessage) onError
      //
      }) async {
    state = const AsyncLoading();

    try {
      final CreateSakit create = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(
              idUser,
              StringUtils.midnightDate(DateTime.parse(dtTgl))
                  .replaceAll('.000', ''),
              StringUtils.midnightDate(DateTime.now())
                  .toString()
                  .replaceAll('.000', ''));

      // 1. Calc jumlah harito substract sundays and saturdays
      final int jumlahhari =
          _getJumlahHari(create, DateTime.parse(dtTgl), DateTime.now());

      await _validateJmlHariUpdate(
        jumlahhari: jumlahhari,
        tglAwalInDateTime: DateTime.parse(dtTgl),
        tglAkhirInDateTime: DateTime.now(),
      );

      state = await AsyncValue.guard(
          () => ref.read(createDtPcRepositoryProvider).updateDtPc(
                id: id,
                idUser: idUser,
                ket: ket,
                dtTgl: dtTgl,
                jam: jam,
                kategori: kategori,
                uUser: uUser,
              ));
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  _validateJmlHariSubmit({
    required int jumlahhari,
    required String kategori,
    required DateTime tglAwalInDateTime,
    required DateTime tglAkhirInDateTime,
  }) {
    final int daysDiff =
        tglAkhirInDateTime.difference(tglAwalInDateTime).inDays;
    // final bool isFullAkses = ref.read(userNotifierProvider).user.fullAkses!;

    if (daysDiff >= 1 && kategori == 'DT') {
      throw AssertionError('Tanggal input lewat dari 1 hari');
    }

    if (daysDiff >= 3 && kategori == 'PC') {
      throw AssertionError('Tanggal input lewat dari 1 hari');
    }
  }

  Future<void> _validateJmlHariUpdate({
    required int jumlahhari,
    required DateTime tglAwalInDateTime,
    required DateTime tglAkhirInDateTime,
  }) async {
    final int daysDiff =
        tglAkhirInDateTime.difference(tglAwalInDateTime).inDays;
    // final bool isFullAkses = ref.read(userNotifierProvider).user.fullAkses!;

    if (daysDiff >= 1) {
      throw AssertionError('Tanggal input lewat dari 1 hari');
    }
  }

  int _getJumlahHari(
      //
      CreateSakit create,
      DateTime tglAwalInDateTime,
      DateTime tglAkhirInDateTime) {
    log('create $create');
    if (create.jadwalSabtu!.isNotEmpty && create.bulanan == false) {
      return calcDiffSaturdaySunday(tglAwalInDateTime, tglAkhirInDateTime);
    } else if (create.jadwalSabtu!.isEmpty || create.bulanan == true) {
      return calcDiffSunday(tglAwalInDateTime, tglAkhirInDateTime);
    } else {
      return 0;
    }
  }

  int calcDiffSaturdaySunday(DateTime startDate, DateTime endDate) {
    int nbDays = 0;
    DateTime currentDay = startDate;

    while (currentDay.isBefore(endDate)) {
      currentDay = currentDay.add(Duration(days: 1));

      if (currentDay.weekday == DateTime.saturday &&
          currentDay.weekday == DateTime.sunday) {
        nbDays += 1;
      }
    }

    return nbDays;
  }

  int calcDiffSunday(DateTime startDate, DateTime endDate) {
    int nbDays = 0;
    DateTime currentDay = startDate;

    while (currentDay.isBefore(endDate)) {
      currentDay = currentDay.add(Duration(days: 1));

      if (currentDay.weekday == DateTime.saturday) {
        nbDays += 1;
      }
    }

    return nbDays;
  }
}
