import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/user/user_model.dart';
import '../../../sakit/create_sakit/application/create_sakit.dart';
import '../../../sakit/create_sakit/application/create_sakit_notifier.dart';
import '../../../shared/providers.dart';
import '../infrastructure/create_cuti_remote_service.dart';
import '../infrastructure/create_cuti_repository.dart';
import 'alasan_cuti.dart';
import 'jenis_cuti.dart';

part 'create_cuti_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateCutiRemoteService createCutiRemoteService(
    CreateCutiRemoteServiceRef ref) {
  return CreateCutiRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CreateCutiRepository createCutiRepository(CreateCutiRepositoryRef ref) {
  return CreateCutiRepository(
    ref.watch(createCutiRemoteServiceProvider),
  );
}

@riverpod
class JenisCutiNotifier extends _$JenisCutiNotifier {
  @override
  FutureOr<List<JenisCuti>> build() async {
    return ref.read(createCutiRepositoryProvider).getJenisCuti();
  }
}

@riverpod
class AlasanCutiNotifier extends _$AlasanCutiNotifier {
  @override
  FutureOr<List<AlasanCuti>> build() async {
    return ref.read(createCutiRepositoryProvider).getAlasanEmergency();
  }
}

@riverpod
class CreateCutiNotifier extends _$CreateCutiNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> submitCuti(
      {
      //
      required String tglAwal,
      required String tglAkhir,
      required String keterangan,
      required String jenisCuti,
      required String alasanCuti,
      required Future<void> Function(String errMessage) onError}) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;

    try {
      final CreateSakit create = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(user, tglAwal, tglAkhir);

      debugger();

      await _processCuti(
        user: user,
        create: create,
        tglAwal: tglAwal,
        tglAkhir: tglAkhir,
        jenisCuti: jenisCuti,
        alasanCuti: alasanCuti,
        keterangan: keterangan,
      );
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  /* 
    MUTATION VARIABLES

    to submitCuti, mutate the following variables
      dateMasuk: dateMasuk,
      tahunCuti: tahunCuti,
      totalHariCutiBaru: totalHariCutiBaru,
      totalHariCutiTidakBaru: totalHariCutiTidakBaru,

    for table insertion
  */
  Future<void> _processCuti({
    required CreateSakit create,
    required String tglAwal,
    required String tglAkhir,
    required String keterangan,
    required String jenisCuti,
    required String alasanCuti,
    required UserModelWithPassword user,
  }) async {
    // 1. CALC JUMLAH HARI
    final tglAwalInDateTime = DateTime.parse(tglAwal);
    final tglAkhirInDateTime = DateTime.parse(tglAkhir);

    final int jumlahhari =
        _getJumlahHari(create, tglAwalInDateTime, tglAkhirInDateTime);

    // VALIDATE DATA MASTER CUTI
    // await _validateMasterCuti(create: create, jenisCuti: jenisCuti);

    // final isSpvOrHrd = ref.read(userNotifierProvider).user.isSpvOrHrd!;

    // if (!isSpvOrHrd) {
    //   await _notHrCondition(
    //       jumlahhari: jumlahhari,
    //       tglAwalInDateTime: tglAwalInDateTime,
    //       tglAkhirInDateTime: tglAkhirInDateTime);
    // }

    // if ((jenisCuti == 'CE' && alasanCuti.isEmpty) ||
    //     (jenisCuti == 'CE' && alasanCuti == 'A0')) {
    //   throw AssertionError('Cuti Emergency wajib memilih alasan!');
    // }

    // totalHariCutiBaru MUTATION
    final int totalHariCutiBaru = create.createSakitCuti!.cutiBaru! -
        (tglAkhirInDateTime.difference(tglAwalInDateTime).inDays -
            jumlahhari -
            create.hitungLibur!);

    // totalHariCutiTidakBaru MUTATION
    final int totalHariCutiTidakBaru = create.createSakitCuti!.cutiTidakBaru! -
        (tglAkhirInDateTime.difference(tglAwalInDateTime).inDays -
            jumlahhari -
            create.hitungLibur!);

    debugger();

    final DateTime openDateJan =
        DateTime(create.createSakitCuti!.openDate!.year, 1, 1);
    final openDateMax =
        DateTime(create.createSakitCuti!.openDate!.year + 1, 6, 30);

    /* 
      MUTATION VARIABLE 
      final DateTime? dateMasuk;
    */
    final DateTime? dateMasuk;

    final createMasukInDateTime = DateTime.parse(create.masuk!);

    // 1. Mendapatkan date Masuk untuk dikirim
    //    ke proses insert
    //

    //
    //    jika masuk saat bulan februari
    if (createMasukInDateTime.month == 2) {
      // dateMasuk MUTATION
      dateMasuk = DateTime(
          createMasukInDateTime.year + 2, createMasukInDateTime.month - 1, 28);
    }

    //
    //    jika masuk saat bulan januari
    else if (createMasukInDateTime.month == 1) {
      // dateMasuk MUTATION
      dateMasuk = DateTime(createMasukInDateTime.year + 1, 12, 31);
    } else {
      // dateMasuk MUTATION
      dateMasuk = DateTime(
          createMasukInDateTime.year + 2, createMasukInDateTime.month - 1, 30);
    }

    final Duration tglAwaltglMasukDiff =
        tglAwalInDateTime.difference(dateMasuk);

    /* 
      MUTATION VARIABLE 
      final String? tahunCuti;
    */
    final String? tahunCuti;

    // 2. Mendapatkan tahun Cuti untuk dikirim
    //    ke proses insert
    //
    if (create.createSakitCuti!.cutiBaru == 0 ||
        create.createSakitCuti!.cutiBaru! > 0 &&
            !tglAwaltglMasukDiff.isNegative) {
      // tahunCuti MUTATION
      tahunCuti = create.createSakitCuti!.tahunCutiTidakBaru!;
    } else {
      // tahunCuti MUTATION
      tahunCuti = create.createSakitCuti!.tahunCutiBaru!;
    }

    // 3. Menghitung Saldo Cuti
    //    dan menghasilkan error jika habis
    //
    final _tahunCutiTidakSamaDenganTahunMasuk =
        tglAkhirInDateTime.year != createMasukInDateTime.year;
    final _tahunCutiTidakSamaDenganTahunMasukPlusOneYear =
        tglAkhirInDateTime.year != createMasukInDateTime.year + 1;

    bool validateTahunCuti = (_tahunCutiTidakSamaDenganTahunMasuk ||
        _tahunCutiTidakSamaDenganTahunMasukPlusOneYear);
    bool jenisCutiEmergencyOrTahunan = jenisCuti == 'CE' || jenisCuti == 'CT';
    Duration tglMasukOpenDateJanDiff =
        createMasukInDateTime.difference(openDateJan);

    if (create.createSakitCuti!.cutiTidakBaru! > 0 &&
        validateTahunCuti &&
        jenisCutiEmergencyOrTahunan &&
        tglMasukOpenDateJanDiff.isNegative) {
      debugger();
      throw AssertionError(
          "Saldo Cuti ${create.createSakitCuti!.closeDate!.year} Habis! Belum Masuk Periode Cuti ${create.createSakitCuti!.tahunCutiTidakBaru} ");
    }

    // 4. Saldo Cuti Awal (Tahun Masuk)
    //
    //    Jika user masuk kerja saat tahun_cuti sama dengan tahun masuk
    //
    //    variables :
    //
    //    final createMasukInDateTime = DateTime.parse(create.masuk!);
    //    final tglAwaltglMasukDiff = tglAwalInDateTime.difference(dateMasuk);
    //
    /*     
        totalHariCutiBaru =  createSakitCuti!.cutiBaru! -
                             tglAkhirInDateTime.difference(tglAwalInDateTime).inDays -
                             jumlahhari -
                             create.hitungLibur!;
    */

    final createSakitCuti = create.createSakitCuti;

    final bool saldoCutiTidakCukup = totalHariCutiBaru < 0;
    final bool tahunCutiSamaDenganTahunMasuk =
        tglAkhirInDateTime.year == createMasukInDateTime.year;

    if (tglAkhirInDateTime.year == createMasukInDateTime.year) {
      if (saldoCutiTidakCukup && tahunCutiSamaDenganTahunMasuk) {
        throw AssertionError(
            'Sisa Saldo Cuti Tidak Cukup! Saldo Cuti Anda Tersisa ${createSakitCuti!.cutiBaru} untuk periode ${createSakitCuti.tahunCutiTidakBaru}');
      }
    }

    // untuk mereset cuti baru jika tgl_start melebihi tanggal expired (datemsk)
    if (createSakitCuti!.cutiBaru! > 0 && !tglAwaltglMasukDiff.isNegative) {
      // BELOM UPDATE QUERY

      throw AssertionError(
          "Saldo Periode ${createMasukInDateTime.year} Tersisa ${createSakitCuti.cutiBaru} Dan Telah Expired! Silahkan Refresh Page dan Input Kembali");
    }

    // 5. Saldo Cuti Setelah Dua Tahun Masuk dan Seterusnya (Tahun Masuk + 2)
    //
    //
    //    Jika masa kerja user sudah 2 tahun atau lebih
    //
    //    variables :
    //
    //    final createMasukInDateTime = DateTime.parse(create.masuk!);
    //    final openDateMax = DateTime(create.createSakitCuti!.openDate!.year + 1, 6, 30);
    //
    /*     
        totalHariCutiTidakBaru =  createSakitCuti!.cutiTidakBaru! -
                                  tglAkhirInDateTime.difference(tglAwalInDateTime).inDays -
                                  jumlahhari -
                                  create.hitungLibur!;
    */

    final tglAwaltglOpenDateMaxDiff = tglAwalInDateTime.difference(openDateMax);

    final bool saldoCutiTidakBaruTidakCukup = totalHariCutiTidakBaru < 0;

    if (tglAkhirInDateTime.year == createMasukInDateTime.year &&
        tglAkhirInDateTime.year == createMasukInDateTime.year + 1) {
      if (saldoCutiTidakBaruTidakCukup) {
        throw AssertionError(
            "Sisa Saldo Cuti Tidak Cukup! Saldo Cuti Anda Tersisa ${createSakitCuti.cutiTidakBaru} Untuk Periode ${createSakitCuti.tahunCutiTidakBaru}");
      }
    }

    // untuk mereset cuti tidak baru jika tgl_start melebihi tanggal date max
    if (createSakitCuti.cutiTidakBaru! > 0 &&
        !tglAwaltglOpenDateMaxDiff.isNegative) {
      // BELOM UPDATE QUERY

      throw AssertionError(
          "Saldo Periode ${create.createSakitCuti!.closeDate!.year} Tersisa ${createSakitCuti.cutiTidakBaru} Dan Telah Expired! Silahkan Refresh Page dan Input Kembali");
    }

    // cek mutation
    debugger();

    // final String messageContent =
    //     " ( Testing Apps ) Terdapat Waiting Approve Pengajuan Izin Sakit Baru Telah Diinput Oleh : ${user.nama} ";
    // await _sendWaToHead(idUser: user.idUser!, messageContent: messageContent);

    // get totalHari from previously mutated variable
    // totalHariCutiBaru, totalHariCutiTidakBaru
    // in _processCuti() function
    final int totalHari = _getTotalHari(
      totalHariCutiBaru: totalHariCutiBaru,
      totalHariCutiTidakBaru: totalHariCutiTidakBaru,
      tglAkhirInDateTime: tglAkhirInDateTime,
      createMasukInDateTime: DateTime.parse(create.masuk!),
    );

    // get sisaCuti from previously mutated variabled
    // dateMasuk
    // in _processCuti() function
    final int? sisaCuti = create.createSakitCuti!.cutiBaru == 0 ||
            (create.createSakitCuti!.cutiBaru! > 0 &&
                !tglAwalInDateTime.difference(dateMasuk).isNegative)
        ? create.createSakitCuti!.cutiBaru
        : create.createSakitCuti!.cutiTidakBaru;

    debugger();

    final repo = ref.read(createCutiRepositoryProvider);

    state = await AsyncValue.guard(() => repo.submitCuti(
          // mutated variables
          totalHari: totalHari,
          tahunCuti: tahunCuti!,
          sisaCuti: sisaCuti!,
          // raw variables
          ket: keterangan,
          alasan: alasanCuti,
          jenisCuti: jenisCuti,
          idUser: user.idUser!,
          // date time
          tglStart: tglAwal,
          tglAwalInDateTime: tglAwalInDateTime,
          tglAkhirInDateTime: tglAkhirInDateTime,
        ));
  }

  Future<void> _validateMasterCuti({
    required String jenisCuti,
    required CreateSakit create,
  }) async {
    // 1. CALC TGL MSK
    if (create.masuk == null) {
      throw AssertionError(
          'Tanggal masuk karyawan atau tanggal join kerja masih kosong!');
    }

    //
    // 2. CALC JUMLAH HARI LIBUR
    if (create.hitungLibur == 0) {
      throw AssertionError(
          "Master Data Cuti Anda Belum Ada! Silahkan Hubungi HR");
    }

    final isCutiEmergencyOrTahunan = jenisCuti == 'CE' || jenisCuti == 'CT';

    // 3. CALC JUMLAH MASA KERJA, JIKA KURANG DARI 12 BULAN
    if (DateTime.parse('${create.masuk}').difference(DateTime.now()).inDays <
            365 &&
        isCutiEmergencyOrTahunan) {
      throw AssertionError(
          "Anda Belum Mendapat Hak Cuti, Masa Kerja Belum Setahun!");
    }
  }

  // MUTATION VARIABLES :
  // dateMasuk, tahunCuti, tglAwaltglMasukDiff

  Future<void> _notHrCondition({
    required int jumlahhari,
    required DateTime tglAwalInDateTime,
    required DateTime tglAkhirInDateTime,
  }) async {
    if (!tglAwalInDateTime.difference(tglAkhirInDateTime).isNegative) {
      throw AssertionError(
          'Tanggal Awal Tidak Boleh Lebih Besar Dari Tanggal Akhir');
    }

    if (DateTime.now().difference(tglAwalInDateTime).inDays - jumlahhari > 5) {
      throw AssertionError('Tanggal input lewat dari 5 hari');
    }
  }

  int _getJumlahHari(CreateSakit create, DateTime tglAwalInDateTime,
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

      if (currentDay.weekday != DateTime.saturday &&
          currentDay.weekday != DateTime.sunday) {
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

      if (currentDay.weekday != DateTime.saturday) {
        nbDays += 1;
      }
    }

    return nbDays;
  }

  int _getTotalHari({
    required DateTime createMasukInDateTime,
    required DateTime tglAkhirInDateTime,
    required int totalHariCutiBaru,
    required int totalHariCutiTidakBaru,
  }) {
    if (tglAkhirInDateTime.year == createMasukInDateTime.year &&
        tglAkhirInDateTime.year == createMasukInDateTime.year + 1) {
      debugger();

      return totalHariCutiTidakBaru;
    } else {
      debugger();

      return totalHariCutiBaru;
    }
  }
}
