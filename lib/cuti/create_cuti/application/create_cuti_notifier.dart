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
    required String jenisCuti,
    required String alasanCuti,
    required String keterangan,
    required UserModelWithPassword user,
  }) async {
    final DateTime tglAwalInDateTime = DateTime.parse(tglAwal);
    final DateTime tglAkhirInDateTime = DateTime.parse(tglAkhir);

    // 1. Calc jumlah harito substract sundays and saturdays
    final int jumlahhari =
        _getJumlahHari(create, tglAwalInDateTime, tglAkhirInDateTime);

    // Begin VALIDATE DATA MASTER CUTI
    await _validateMasterCuti(create: create, jenisCuti: jenisCuti);

    final isSpvOrHrd = ref.read(userNotifierProvider).user.isSpvOrHrd!;

    if (!isSpvOrHrd) {
      await _notHrCondition(
          jumlahhari: jumlahhari,
          tglAwalInDateTime: tglAwalInDateTime,
          tglAkhirInDateTime: tglAkhirInDateTime);
    }

    if ((jenisCuti == 'CE' && alasanCuti.isEmpty) ||
        (jenisCuti == 'CE' && alasanCuti == 'A0')) {
      throw AssertionError('Cuti Emergency wajib memilih alasan!');
    }
    // End VALIDATE DATA MASTER CUTI

    // totalHariCutiBaru MUTATION, later to be used
    final int totalHariCutiBaru = create.createSakitCuti!.cutiBaru! -
        (tglAkhirInDateTime.difference(tglAwalInDateTime).inDays - jumlahhari) -
        create.hitungLibur!;

    // totalHariCutiTidakBaru MUTATION, later to be used
    final int totalHariCutiTidakBaru = create.createSakitCuti!.cutiTidakBaru! -
        (tglAkhirInDateTime.difference(tglAwalInDateTime).inDays - jumlahhari) -
        create.hitungLibur!;

    final DateTime openDateJan =
        DateTime(create.createSakitCuti!.openDate!.year, 1, 1);
    final DateTime openDateMax =
        DateTime(create.createSakitCuti!.openDate!.year + 1, 6, 30);
    final createMasukInDateTime = DateTime.parse(create.masuk!);

    /* 
      MUTATION VARIABLE 
      final DateTime? dateMasuk;
    */
    final DateTime? dateMasuk =
        _returnDateMasuk(createMasukInDateTime: createMasukInDateTime);
    final Duration tglAwaltglMasukDiff =
        tglAwalInDateTime.difference(dateMasuk!);

    /* 
      MUTATION VARIABLE 
      final String? tahunCuti;
    */
    final String? tahunCuti = _returnTahunCuti(
      create: create,
      tglAwaltglMasukDiff: tglAwaltglMasukDiff.inDays,
    );

    // 3. Menghitung Saldo Cuti
    //    dan menghasilkan error jika habis
    //
    final sayaCutiDiTahunMasuk =
        tglAkhirInDateTime.year == createMasukInDateTime.year;
    final _sayaCutiDiTahunMasukBerikutnya =
        tglAkhirInDateTime.year == createMasukInDateTime.year + 1;

    bool sayaMasihDataCutiBaru = create.createSakitCuti!.cutiTidakBaru! > 0;
    bool validateTahunCuti =
        (!sayaCutiDiTahunMasuk || !_sayaCutiDiTahunMasukBerikutnya);
    bool jenisCutiEmergencyOrTahunan = jenisCuti == 'CE' || jenisCuti == 'CT';
    bool tglCutiLebihKecilDariOpenDate =
        createMasukInDateTime.difference(openDateJan).isNegative;

    if (sayaMasihDataCutiBaru &&
        validateTahunCuti &&
        jenisCutiEmergencyOrTahunan &&
        tglCutiLebihKecilDariOpenDate) {
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

    if (sayaCutiDiTahunMasuk) {
      if (saldoCutiTidakCukup) {
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
        !tglAwalInDateTime.difference(openDateMax).isNegative) {
      // BELOM UPDATE QUERY

      throw AssertionError(
          "Saldo Periode ${create.createSakitCuti!.closeDate!.year} Tersisa ${createSakitCuti.cutiTidakBaru} Dan Telah Expired! Silahkan Refresh Page dan Input Kembali");
    }

    // final String messageContent =
    //     " ( Testing Apps ) Terdapat Waiting Approve Pengajuan Izin Sakit Baru Telah Diinput Oleh : ${user.nama} ";
    // await _sendWaToHead(idUser: user.idUser!, messageContent: messageContent);

    // get totalHari from
    // totalHariCutiBaru, totalHariCutiTidakBaru
    // in _processCuti() function
    final int totalHari = _returnTotalHari(
      tglAkhirInDateTime: tglAkhirInDateTime,
      totalHariCutiBaru: totalHariCutiBaru,
      totalHariCutiTidakBaru: totalHariCutiTidakBaru,
      createMasukInDateTime: DateTime.parse(create.masuk!),
    );

    // get sisaCuti from
    // dateMasuk
    // in _processCuti() function
    final int? sisaCuti = create.createSakitCuti!.cutiBaru == 0 ||
            (create.createSakitCuti!.cutiBaru! > 0 &&
                !tglAwalInDateTime.difference(dateMasuk).isNegative)
        ? create.createSakitCuti!.cutiBaru
        : create.createSakitCuti!.cutiTidakBaru;

    debugger();

    state = await AsyncValue.guard(
        () => ref.read(createCutiRepositoryProvider).submitCuti(
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
    // if (create == ) {
    //   throw AssertionError(
    //       "Master Data Cuti Anda Belum Ada! Silahkan Hubungi HR");
    // }

    final isCutiEmergencyOrTahunan = jenisCuti == 'CE' || jenisCuti == 'CT';

    // 3. CALC JUMLAH MASA KERJA, JIKA KURANG DARI 12 BULAN
    if (DateTime.now().difference(DateTime.parse(create.masuk!)).inDays < 365 &&
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
    if (!tglAkhirInDateTime.difference(tglAwalInDateTime).isNegative) {
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

  int _returnTotalHari({
    required DateTime createMasukInDateTime,
    required DateTime tglAkhirInDateTime,
    required int totalHariCutiBaru,
    required int totalHariCutiTidakBaru,
  }) {
    if (tglAkhirInDateTime.year == createMasukInDateTime.year &&
        tglAkhirInDateTime.year == createMasukInDateTime.year + 1) {
      return totalHariCutiTidakBaru;
    } else {
      return totalHariCutiBaru;
    }
  }

  DateTime _returnDateMasuk({required DateTime createMasukInDateTime}) {
    // 1. Mendapatkan date Masuk untuk dikirim
    //    ke proses insert
    //

    //
    //    jika masuk saat bulan februari
    if (createMasukInDateTime.month == 2) {
      // dateMasuk MUTATION
      return DateTime(
          createMasukInDateTime.year + 2, createMasukInDateTime.month - 1, 28);
    }

    //
    //    jika masuk saat bulan januari
    else if (createMasukInDateTime.month == 1) {
      // dateMasuk MUTATION
      return DateTime(createMasukInDateTime.year + 1, 12, 31);
    } else {
      // dateMasuk MUTATION
      return DateTime(
          createMasukInDateTime.year + 2, createMasukInDateTime.month - 1, 30);
    }
  }

  String _returnTahunCuti(
      {required CreateSakit create, required int tglAwaltglMasukDiff}) {
    // 2. Mendapatkan tahun Cuti untuk dikirim
    //    ke proses insert
    //
    if (create.createSakitCuti!.cutiBaru == 0 ||
        create.createSakitCuti!.cutiBaru! > 0 &&
            !tglAwaltglMasukDiff.isNegative) {
      // tahunCuti MUTATION
      return create.createSakitCuti!.tahunCutiTidakBaru!;
    } else {
      // tahunCuti MUTATION
      return create.createSakitCuti!.tahunCutiBaru!;
    }
  }
}
