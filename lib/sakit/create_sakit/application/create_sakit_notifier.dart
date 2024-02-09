import 'dart:developer';

import 'package:face_net_authentication/mst_karyawan_cuti/application/mst_karyawan_cuti_notifier.dart';
import 'package:face_net_authentication/sakit/create_sakit/application/create_sakit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';
import '../../../user/application/user_model.dart';
import '../../../wa_head_helper/application/wa_head.dart';
import '../../../wa_head_helper/application/wa_head_helper_notifier.dart';
import '../infrastructure/create_sakit_remote_service.dart';
import '../infrastructure/create_sakit_repository.dart';

part 'create_sakit_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateSakitRemoteService createSakitRemoteService(
    CreateSakitRemoteServiceRef ref) {
  return CreateSakitRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CreateSakitRepository createSakitRepository(CreateSakitRepositoryRef ref) {
  return CreateSakitRepository(
    ref.watch(createSakitRemoteServiceProvider),
  );
}

@riverpod
class CreateSakitNotifier extends _$CreateSakitNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> _sendWaToHead(
      {required int idUser, required String messageContent}) async {
    debugger();

    final List<WaHead> waHeads = await ref
        .read(waHeadHelperNotifierProvider.notifier)
        .getWaHeads(idUser: idUser);

    if (waHeads.isNotEmpty) {
      for (int i = 0; i < waHeads.length; i++) {
        if (waHeads[i].telp1 != null) {
          await ref.read(sendWaNotifierProvider.notifier).sendWa(
              phone: int.parse(waHeads[i].telp1!),
              idUser: waHeads[i].idUserHead!,
              idDept: waHeads[i].idDept!,
              notifTitle: 'Notifikasi HRMS',
              notifContent: '$messageContent');
        } else if (waHeads[i].telp2 != null) {
          await ref.read(sendWaNotifierProvider.notifier).sendWa(
              phone: 6281385367083,
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

  Future<void> submitSakit(
      {
      //
      required String tglAwal,
      required String tglAkhir,
      required String keterangan,
      required String suratDokter,
      required Future<void> Function(String errMessage) onError}
      //
      ) async {
    state = const AsyncLoading();

    final repo = ref.read(createSakitRepositoryProvider);
    final user = ref.read(userNotifierProvider).user;

    try {
      final CreateSakit create = await getCreateSakit(user, tglAwal, tglAkhir);
      final MstKaryawanCuti mstCuti = await ref
          .read(mstKaryawanCutiNotifierProvider.notifier)
          .getSaldoMasterCutiById(user.idUser!);

      final DateTime tglAwalInDateTime = DateTime.parse(tglAwal);
      final DateTime tglAkhirInDateTime = DateTime.parse(tglAkhir);

      final int jumlahhari =
          _calcDiff(create, tglAwalInDateTime, tglAkhirInDateTime);

      await _processSakit(
          create: create,
          mstCuti: mstCuti,
          user: user,
          onError: onError,
          tglAwal: tglAwal,
          tglAkhir: tglAkhir,
          jumlahhari: jumlahhari,
          suratDokter: suratDokter);

      final String messageContent =
          " ( Testing Apps ) Terdapat Waiting Approve Pengajuan Izin Sakit Baru Telah Diinput Oleh : ${user.nama} ";
      await _sendWaToHead(idUser: user.idUser!, messageContent: messageContent);

      state = await AsyncValue.guard(() => repo.submitSakit(
          idUser: user.idUser!,
          ket: keterangan,
          surat: suratDokter,
          cUser: user.nama!,
          tglEnd: tglAkhir,
          tglStart: tglAwal,
          jumlahHari: jumlahhari,
          hitungLibur: create.hitungLibur!));
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<void> updateSakit(
      {
      //
      required int id,
      required String tglAwal,
      required String tglAkhir,
      required String keterangan,
      required String suratDokter,
      required Future<void> Function(String errMessage) onError}
      //
      ) async {
    state = const AsyncLoading();

    final repo = ref.read(createSakitRepositoryProvider);
    final user = ref.read(userNotifierProvider).user;

    try {
      final CreateSakit create = await getCreateSakit(user, tglAwal, tglAkhir);
      final MstKaryawanCuti mstCuti = await ref
          .read(mstKaryawanCutiNotifierProvider.notifier)
          .getSaldoMasterCutiById(user.idUser!);

      final DateTime tglAwalInDateTime = DateTime.parse(tglAwal);
      final DateTime tglAkhirInDateTime = DateTime.parse(tglAkhir);

      final int jumlahhari =
          _calcDiff(create, tglAwalInDateTime, tglAkhirInDateTime);

      await _processSakit(
          create: create,
          mstCuti: mstCuti,
          user: user,
          onError: onError,
          tglAwal: tglAwal,
          tglAkhir: tglAkhir,
          jumlahhari: jumlahhari,
          suratDokter: suratDokter);

      state = await AsyncValue.guard(() => repo.updateSakit(
          id: id,
          idUser: user.idUser!,
          ket: keterangan,
          cUser: user.nama!,
          tglEnd: tglAkhir,
          tglStart: tglAwal,
          surat: suratDokter,
          jumlahHari: jumlahhari,
          hitungLibur: create.hitungLibur!));
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<int> getLastSubmitSakit() {
    final id = ref.read(userNotifierProvider).user.idUser;
    return ref
        .read(createSakitRepositoryProvider)
        .getLastSubmitSakit(idUser: id!);
  }

  Future<void> _processSakit({
    required CreateSakit create,
    required MstKaryawanCuti mstCuti,
    //
    required int jumlahhari,
    required String tglAwal,
    required String tglAkhir,
    required String suratDokter,
    required UserModelWithPassword user,
    required Future<void> onError(String errMessage),
  }) async {
    // 1. CALC JUMLAH HARI

    final DateTime tglAwalInDateTime = DateTime.parse(tglAwal);
    final DateTime tglAkhirInDateTime = DateTime.parse(tglAkhir);

    // JIKA TS
    if (suratDokter == 'TS') {
      await _noSuratCondition(create);
    }

    // SALDO CUTI
    await _calcSaldoCuti(
      create: create,
      mstCuti: mstCuti,
      onError: onError,
      jumlahhari: jumlahhari,
      suratDokter: suratDokter,
      tglAwalInDateTime: tglAwalInDateTime,
      tglAkhirInDateTime: tglAkhirInDateTime,
    );

    if (DateTime.now().difference(tglAwalInDateTime).inDays - jumlahhari > 3) {
      throw AssertionError('Tanggal input lewat dari 3 hari');
    }
  }

  Future<CreateSakit> getCreateSakit(
      UserModelWithPassword user, String tglAwal, String tglAkhir) async {
    if (user.idUser == null) {
      throw AssertionError('ID User Null');
    }

    if (user.IdKary == null) {
      throw AssertionError('ID Karyawan Null');
    }

    final create = await ref.read(createSakitRepositoryProvider).getCreateSakit(
          tglAwal: tglAwal,
          tglAkhir: tglAkhir,
          idUser: user.idUser!,
          idKaryawan: int.parse(user.IdKary!),
        );

    //
    return create;
  }

  Future<void> _calcSaldoCuti(
      {required CreateSakit create,
      required MstKaryawanCuti mstCuti,
      //
      required int jumlahhari,
      required String suratDokter,
      required DateTime tglAkhirInDateTime,
      required DateTime tglAwalInDateTime,
      required Future<void> Function(String errMessage) onError}) async {
    //

    final createMasukInDateTime = DateTime.parse('${create.masuk}');
    final createMasukInDateTimePlusOne =
        createMasukInDateTime.add(Duration(days: 365));

    final openDate = mstCuti.openDate;
    final closeDateInDateTime = mstCuti.closeDate!;

    final jumlahCutiTidakBaru = mstCuti.cutiTidakBaru!;
    final diffSinceOpenDate = DateTime.now().difference(openDate!).inDays;

    final isSameYear = tglAwalInDateTime.year != createMasukInDateTime.year ||
        tglAwalInDateTime.year != createMasukInDateTimePlusOne.year;

    if (jumlahCutiTidakBaru > 0 &&
        isSameYear &&
        suratDokter == 'TS' &&
        diffSinceOpenDate > 0) {
      throw AssertionError(
          " Saldo Cuti ${closeDateInDateTime.year} Habis! Belum Masuk Periode Cuti ${mstCuti.tahunCutiTidakBaru} ");
    }

    final cutiBaru = mstCuti.cutiBaru!;
    final endStartPlusOneDiffInDays = tglAkhirInDateTime
        .difference(tglAwalInDateTime.add(Duration(days: 1)))
        .inDays;
    final totalHariCutiBaru = cutiBaru -
        (endStartPlusOneDiffInDays - jumlahhari) -
        create.hitungLibur!;

    if (cutiBaru > 0 && suratDokter == 'TS') {
      if (totalHariCutiBaru < 0) {
        throw AssertionError("Sisa Saldo Cuti Tidak Cukup! " +
            " Saldo Cuti Anda Tersisa $cutiBaru  Untuk Periode ${mstCuti.tahunCutiBaru} ");
      }
    }

    final cutiTidakBaru = mstCuti.cutiTidakBaru!;
    final totalHariCutiTidakBaru = cutiTidakBaru -
        (endStartPlusOneDiffInDays - jumlahhari) -
        create.hitungLibur!;

    if (totalHariCutiTidakBaru < 0) {
      throw AssertionError("Sisa Saldo Cuti Tidak Cukup! " +
          " Saldo Cuti Anda Tersisa $cutiTidakBaru  Untuk Periode ${mstCuti.tahunCutiTidakBaru} ");
    }
  }

  Future<void> _noSuratCondition(
    CreateSakit create,
  ) async {
    //
    // 2. CALC JUMLAH HARI LIBUR
    // if (create.hitungLibur == 0) {
    //   throw AssertionError(
    //       "Master Data Cuti Anda Belum Ada! Silahkan Hubungi HR");
    // }
    //
    // 3. CALC JUMLAH MASA KERJA, JIKA KURANG DARI 12 BULAN
    if (DateTime.now().difference(DateTime.parse(create.masuk!)).inDays < 365) {
      throw AssertionError(
          "Anda Belum Mendapat Hak Cuti, Masa Kerja Belum Setahun!");
    }
  }
}

int _calcDiff(CreateSakit create, DateTime tglAwalInDateTime,
    DateTime tglAkhirInDateTime) {
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

// final repo = ref.read(createSakitRepositoryProvider);

//     final user = ref.read(userNotifierProvider).user;

//     if (user.idUser == null) {
//       throw AssertionError('ID User Null');
//     }

//     if (user.IdKary == null) {
//       throw AssertionError('ID Karyawan Null');
//     }

//     final create = await repo.getCreateSakit(
//         idUser: user.idUser!,
//         idKaryawan: int.parse(user.IdKary!),
//         tglAwal: '2024-01-08 00:00:00',
//         tglAkhir: '2024-01-011 00:00:00');

//     log('createSakit $create');
