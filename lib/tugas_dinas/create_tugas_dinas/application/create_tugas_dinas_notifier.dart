// ignore_for_file: sdk_version_since

import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../sakit/create_sakit/application/create_sakit.dart';
import '../../../sakit/create_sakit/application/create_sakit_notifier.dart';
import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';
import '../../../wa_head_helper/application/wa_head.dart';
import '../../../wa_head_helper/application/wa_head_helper_notifier.dart';

import '../infrastructure/create_tugas_dinas_remote_service.dart';
import '../infrastructure/create_tugas_dinas_repository.dart';
import 'jenis_tugas_dinas.dart';
import 'user_list.dart';

part 'create_tugas_dinas_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateTugasDinasRemoteService createTugasDinasRemoteService(
    CreateTugasDinasRemoteServiceRef ref) {
  return CreateTugasDinasRemoteService(
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CreateTugasDinasRepository createTugasDinasRepository(
    CreateTugasDinasRepositoryRef ref) {
  return CreateTugasDinasRepository(
    ref.watch(createTugasDinasRemoteServiceProvider),
  );
}

@riverpod
class JenisTugasDinasNotifier extends _$JenisTugasDinasNotifier {
  @override
  FutureOr<List<JenisTugasDinas>> build() async {
    return ref.read(createTugasDinasRepositoryProvider).getJenisTugasDinas();
  }
}

@riverpod
class PemberiTugasDinasNotifier extends _$PemberiTugasDinasNotifier {
  @override
  FutureOr<List<UserList>> build() async {
    return [];
  }

  Future<void> getPemberiTugasListNamed(String nama) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => ref
        .read(createTugasDinasRepositoryProvider)
        .getPemberiTugasListNamed(nama));
  }
}

@riverpod
class CreateTugasDinasNotifier extends _$CreateTugasDinasNotifier {
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

  Future<void> submitTugasDinas(
      {required int idUser,
      required int idPemberi,
      required String ket,
      required String tglAwal,
      required String tglAkhir,
      required String jamAwal,
      required String jamAkhir,
      required String kategori,
      required String perusahaan,
      required String lokasi,
      required String cUser,
      required bool khusus,
      required Future<void> Function(String errMessage) onError}) async {
    state = const AsyncLoading();

    try {
      // debugger();
      final CreateSakit create = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(idUser, tglAwal, tglAkhir);
      _verifyDate(create, tglAwal, tglAkhir, kategori, khusus);

      await ref.read(createTugasDinasRepositoryProvider).submitTugasDinas(
          idUser: idUser,
          idPemberi: idPemberi,
          ket: ket,
          tglAwal: tglAwal,
          tglAkhir: tglAkhir,
          jamAwal: jamAwal,
          jamAkhir: jamAkhir,
          kategori: kategori,
          perusahaan: perusahaan,
          lokasi: lokasi,
          cUser: cUser,
          khusus: khusus);

      final String messageContent =
          " ( Testing Apps ) Terdapat Waiting Aprove Pengajuan Tugas Dinas Baru Telah Diinput Oleh : $cUser ";
      await _sendWaToHead(idUser: idUser, messageContent: messageContent);

      state = const AsyncValue.data('Sukses Menginput Form Tugas Dinas');
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<void> updateTugasDinas(
      {required int id,
      required int idUser,
      required int idPemberi,
      required String ket,
      required String tglAwal,
      required String tglAkhir,
      required String jamAwal,
      required String jamAkhir,
      required String kategori,
      required String perusahaan,
      required String lokasi,
      required bool khusus,
      required String uUser,
      required Future<void> Function(String errMessage) onError}) async {
    state = const AsyncLoading();

    try {
      debugger();
      final CreateSakit create = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(idUser, tglAwal, tglAkhir);
      _verifyDate(create, tglAwal, tglAkhir, kategori, khusus);

      await ref.read(createTugasDinasRepositoryProvider).updateTugasDinas(
            id: id,
            idUser: idUser,
            idPemberi: idPemberi,
            ket: ket,
            tglAwal: tglAwal,
            tglAkhir: tglAkhir,
            jamAwal: jamAwal,
            jamAkhir: jamAkhir,
            kategori: kategori,
            perusahaan: perusahaan,
            lokasi: lokasi,
            khusus: khusus,
            uUser: uUser,
          );

      state = const AsyncValue.data('Sukses Mengupdate Form Tugas Dinas');
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  void _verifyDate(CreateSakit create, String tglAwal, String tglAkhir,
      String kategori, bool khusus) {
    // 1. Calc jumlah harito substract sundays and saturdays
    final int _jumlahhari = _getJumlahHari(
        create, DateTime.parse(tglAwal), DateTime.parse(tglAkhir));

    int _diffIndays() =>
        DateTime.now().difference(DateTime.parse(tglAwal)).inDays + _jumlahhari;

    int _diffIndaysPast() =>
        DateTime.now().difference(DateTime.parse(tglAwal)).inDays - _jumlahhari;

    final bool fullAkses = ref.read(userNotifierProvider).user.fullAkses!;

    if (kategori == 'LK' && khusus == false) {
      final bool lewatDariMinTigaHari = _diffIndays() > -2;
      // final bool fullAkses = ref.read(userNotifierProvider).user.fullAkses

      if (lewatDariMinTigaHari && fullAkses == false && khusus == false) {
        throw AssertionError('Tanggal input lewat dari -3 hari');
      }
    } else {
      if (_diffIndaysPast() > 0 && fullAkses == false && khusus == false) {
        throw AssertionError('Tanggal input lewat dari sehari');
      }
    }

    if (DateTime.parse(tglAwal)
            .difference(DateTime.parse(tglAkhir))
            .isNegative ==
        false) {
      throw AssertionError(
          'Tanggal Awal Tidak Boleh Lebih Besar Dari Tanggal Akhir');
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
