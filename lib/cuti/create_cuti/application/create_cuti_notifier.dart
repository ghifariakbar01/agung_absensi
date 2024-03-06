import 'package:face_net_authentication/mst_karyawan_cuti/application/mst_karyawan_cuti_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../../sakit/create_sakit/application/create_sakit.dart';

import '../../../sakit/create_sakit/application/create_sakit_notifier.dart';
import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';
import '../../../wa_head_helper/application/wa_head.dart';
import '../../../wa_head_helper/application/wa_head_helper_notifier.dart';
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

  Future<void> submitCuti(
      {
      //
      required int idUser,
      required String tglAwal,
      required String tglAkhir,
      required String keterangan,
      required String jenisCuti,
      required String alasanCuti,
      required Future<void> Function(String errMessage) onError
      //
      }) async {
    state = const AsyncLoading();

    try {
      final CreateSakit create = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(idUser, tglAwal, tglAkhir);
      final MstKaryawanCuti mstCuti = await ref
          .read(mstKaryawanCutiNotifierProvider.notifier)
          .getSaldoMasterCutiById(idUser);

      await _finalizeSubmit(
        idUser: idUser,
        create: create,
        mstCuti: mstCuti,
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

  Future<void> updateCuti(
      {
      //
      required int idUser,
      required int idCuti,
      required String tglAwal,
      required String tglAkhir,
      required String keterangan,
      required String jenisCuti,
      required String alasanCuti,
      required Future<void> Function(String errMessage) onError
      //
      }) async {
    state = const AsyncLoading();

    try {
      final CreateSakit create = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(idUser, tglAwal, tglAkhir);
      final MstKaryawanCuti mstCuti = await ref
          .read(mstKaryawanCutiNotifierProvider.notifier)
          .getSaldoMasterCutiById(idUser);

      await _finalizeUpdate(
        idCuti: idCuti,
        idUser: idUser,
        create: create,
        mstCuti: mstCuti,
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

    to submitCuti, initialize the following variables

      dateMasuk: dateMasuk,
      tahunCuti: tahunCuti,
      totalHariCutiBaru: totalHariCutiBaru,
      totalHariCutiTidakBaru: totalHariCutiTidakBaru,

    for table insertion
  */
  Future<void> _finalizeSubmit({
    required int idUser,
    required String tglAwal,
    required String tglAkhir,
    required String jenisCuti,
    required String alasanCuti,
    required String keterangan,
    required CreateSakit create,
    required MstKaryawanCuti mstCuti,
  }) async {
    final DateTime tglAwalInDateTime = DateTime.parse(tglAwal);
    final DateTime tglAkhirInDateTime = DateTime.parse(tglAkhir);

    // 1. Calc jumlah harito substract sundays and saturdays
    final int jumlahhari =
        _getJumlahHari(create, tglAwalInDateTime, tglAkhirInDateTime);

    // Begin VALIDATE DATA MASTER CUTI
    await _validateMasterCuti(create: create, jenisCuti: jenisCuti);

    final hrd = ref.read(userNotifierProvider).user.fin;

    if (!isHrdOrSpv(hrd)) {
      await _notHrCondition(
          jenisCuti: jenisCuti,
          jumlahhari: jumlahhari,
          tglAwalInDateTime: tglAwalInDateTime,
          tglAkhirInDateTime: tglAkhirInDateTime);
    }

    if ((jenisCuti == 'CE' && alasanCuti.isEmpty) ||
        (jenisCuti == 'CE' && alasanCuti == 'A0')) {
      throw AssertionError('Cuti Emergency wajib memilih alasan!');
    }
    // End VALIDATE DATA MASTER CUTI

    final int totalHariCutiBaru = mstCuti.cutiBaru! -
        (tglAkhirInDateTime.difference(tglAwalInDateTime).inDays - jumlahhari) -
        create.hitungLibur!;

    final int totalHariCutiTidakBaru = mstCuti.cutiTidakBaru! -
        (tglAkhirInDateTime.difference(tglAwalInDateTime).inDays - jumlahhari) -
        create.hitungLibur!;

    final DateTime openDateJan = DateTime(mstCuti.openDate!.year, 1, 1);

    final DateTime createMasukInDateTime = DateTime.parse(create.masuk!);

    /* 
      dateMasuk untuk menghitung periode kapan cuti digunakan
    */
    final DateTime? dateMasuk =
        _returnDateMasuk(createMasukInDateTime: createMasukInDateTime);
    final Duration tglAwaltglMasukDiff =
        tglAwalInDateTime.difference(dateMasuk!);

    /* 
      tahunCuti untuk menghitung tahun kapan cuti digunakan
      dalam periode
    */
    final String? tahunCuti = _returnTahunCuti(
      mstCuti: mstCuti,
      tglAwaltglMasukDiff: tglAwaltglMasukDiff.inDays,
    );

    // 3. Menghitung Saldo Cuti
    //    dan menghasilkan error jika habis
    //

    await _validateSaldoCuti(
      idUser: idUser,
      create: create,
      mstCuti: mstCuti,
      jenisCuti: jenisCuti,
      dateMasuk: dateMasuk,
      tahunCuti: int.parse(tahunCuti!),
      //
      openDateJan: openDateJan,
      tglAwalInDateTime: tglAwalInDateTime,
      totalHariCutiBaru: totalHariCutiBaru,
      totalHariCutiTidakBaru: totalHariCutiTidakBaru,
    );

    final syarat2 = (mstCuti.cutiBaru! > 0 &&
        !dateMasuk.difference(tglAwalInDateTime).isNegative);

    final int? sisaCuti = mstCuti.cutiBaru == 0 || syarat2
        ? mstCuti.cutiBaru
        : mstCuti.cutiTidakBaru;

    final cUser = ref.read(userNotifierProvider).user.nama;
    final String messageContent =
        " ( Testing Apps ) Terdapat Waiting Aprrove Pengajuan Cuti Baru Telah Diinput Oleh : $cUser ";
    await _sendWaToHead(idUser: idUser, messageContent: messageContent);

    state = await AsyncValue.guard(
        () => ref.read(createCutiRepositoryProvider).submitCuti(
              jumlahHari: jumlahhari,
              hitungLibur: create.hitungLibur!,
              tahunCuti: tahunCuti,
              sisaCuti: sisaCuti!,
              // raw variables
              ket: keterangan,
              alasan: alasanCuti,
              jenisCuti: jenisCuti,
              idUser: idUser,
              // date time
              tglAwalInDateTime: tglAwalInDateTime,
              tglAkhirInDateTime: tglAkhirInDateTime,
            ));
  }

  Future<void> _finalizeUpdate({
    required int idCuti,
    required int idUser,
    required String tglAwal,
    required String tglAkhir,
    required String jenisCuti,
    required String alasanCuti,
    required String keterangan,
    required CreateSakit create,
    required MstKaryawanCuti mstCuti,
  }) async {
    final DateTime tglAwalInDateTime = DateTime.parse(tglAwal);
    final DateTime tglAkhirInDateTime = DateTime.parse(tglAkhir);

    // 1. Calc jumlah harito substract sundays and saturdays
    final int jumlahhari =
        _getJumlahHari(create, tglAwalInDateTime, tglAkhirInDateTime);

    // Begin VALIDATE DATA MASTER CUTI
    await _validateMasterCuti(create: create, jenisCuti: jenisCuti);

    final hrd = ref.read(userNotifierProvider).user.fin;

    if (!isHrdOrSpv(hrd)) {
      await _notHrCondition(
          jenisCuti: jenisCuti,
          jumlahhari: jumlahhari,
          tglAwalInDateTime: tglAwalInDateTime,
          tglAkhirInDateTime: tglAkhirInDateTime);
    }

    if ((jenisCuti == 'CE' && alasanCuti.isEmpty) ||
        (jenisCuti == 'CE' && alasanCuti == 'A0')) {
      throw AssertionError('Cuti Emergency wajib memilih alasan!');
    }
    // End VALIDATE DATA MASTER CUTI

    final int totalHariCutiBaru = mstCuti.cutiBaru! -
        (tglAkhirInDateTime.difference(tglAwalInDateTime).inDays - jumlahhari) -
        create.hitungLibur!;

    final int totalHariCutiTidakBaru = mstCuti.cutiTidakBaru! -
        (tglAkhirInDateTime.difference(tglAwalInDateTime).inDays - jumlahhari) -
        create.hitungLibur!;

    final DateTime openDateJan = DateTime(mstCuti.openDate!.year, 1, 1);

    final DateTime createMasukInDateTime = DateTime.parse(create.masuk!);

    /* 
      dateMasuk untuk menghitung periode kapan cuti digunakan
    */
    final DateTime? dateMasuk =
        _returnDateMasuk(createMasukInDateTime: createMasukInDateTime);
    final Duration tglAwaltglMasukDiff =
        tglAwalInDateTime.difference(dateMasuk!);

    /* 
      tahunCuti untuk menghitung tahun kapan cuti digunakan
      dalam periode
    */
    final String? tahunCuti = _returnTahunCuti(
      mstCuti: mstCuti,
      tglAwaltglMasukDiff: tglAwaltglMasukDiff.inDays,
    );

    // 3. Menghitung Saldo Cuti
    //    dan menghasilkan error jika habis
    //

    await _validateSaldoCuti(
      idUser: idUser,
      create: create,
      mstCuti: mstCuti,
      jenisCuti: jenisCuti,
      dateMasuk: dateMasuk,
      tahunCuti: int.parse(tahunCuti!),
      //
      openDateJan: openDateJan,
      tglAwalInDateTime: tglAwalInDateTime,
      totalHariCutiBaru: totalHariCutiBaru,
      totalHariCutiTidakBaru: totalHariCutiTidakBaru,
    );

    final syarat2 = (mstCuti.cutiBaru! > 0 &&
        !dateMasuk.difference(tglAwalInDateTime).isNegative);

    final int? sisaCuti = mstCuti.cutiBaru == 0 || syarat2
        ? mstCuti.cutiBaru
        : mstCuti.cutiTidakBaru;

    final uUser = ref.read(userNotifierProvider).user.nama!;

    state = await AsyncValue.guard(
        () => ref.read(createCutiRepositoryProvider).updateCuti(
              jumlahHari: jumlahhari,
              hitungLibur: create.hitungLibur!,
              tahunCuti: tahunCuti,
              sisaCuti: sisaCuti!,
              // raw variables
              ket: keterangan,
              alasan: alasanCuti,
              jenisCuti: jenisCuti,
              nama: uUser,
              idCuti: idCuti,
              idUser: idUser,
              // date time
              tglAwalInDateTime: tglAwalInDateTime,
              tglAkhirInDateTime: tglAkhirInDateTime,
            ));
  }

  Future<void> _validateSaldoCuti({
    required int idUser,
    required CreateSakit create,
    required MstKaryawanCuti mstCuti,
    //
    required String jenisCuti,
    required int tahunCuti,
    required int totalHariCutiBaru,
    required int totalHariCutiTidakBaru,
    required DateTime openDateJan,
    required DateTime tglAwalInDateTime,
    required DateTime dateMasuk,
  }) async {
    final bool sayaCutiDiTahunMasuk = tahunCuti == dateMasuk.year;
    final bool sayaCutiDiTahunMasukBerikutnya = tahunCuti == dateMasuk.year + 1;

    final bool sayaMasihAdaCutiTidakBaru = mstCuti.cutiTidakBaru! > 0;
    final bool validateTahunCuti =
        (!sayaCutiDiTahunMasuk || !sayaCutiDiTahunMasukBerikutnya);
    final bool jenisCutiEmergencyOrTahunan =
        jenisCuti == 'CE' || jenisCuti == 'CT';
    final bool tglAwalLebihKecilDariOpenDate =
        tglAwalInDateTime.difference(openDateJan).isNegative;

    if (sayaMasihAdaCutiTidakBaru &&
        validateTahunCuti &&
        jenisCutiEmergencyOrTahunan &&
        tglAwalLebihKecilDariOpenDate) {
      throw AssertionError(
          "Saldo Cuti ${mstCuti.closeDate!.year} Habis! Belum Masuk Periode Cuti ${mstCuti.tahunCutiTidakBaru} ");
    }

    final String nama = ref.read(userNotifierProvider).user.nama!;

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
    final bool tglStartLebihDariTglMasuk =
        tglAwalInDateTime.difference(dateMasuk).isNegative == false;

    final bool saldoCutiTidakCukup = totalHariCutiBaru < 0;

    if (sayaCutiDiTahunMasuk) {
      if (saldoCutiTidakCukup) {
        throw AssertionError(
            'Sisa Saldo Cuti Tidak Cukup! Saldo Cuti Anda Tersisa ${mstCuti.cutiBaru} untuk periode ${mstCuti.tahunCutiTidakBaru}');
      }

      if (mstCuti.cutiBaru! > 0 && tglStartLebihDariTglMasuk) {
        await ref.read(createCutiRepositoryProvider).resetCutiTahunMasuk(
            idUser: idUser, nama: nama, masuk: create.masuk!);
      }
    }

    // 5. Saldo Cuti Setelah Setahun Masuk (Tahun Masuk + 1)
    //
    //
    //    Jika masa kerja user sudah 2 tahun atau lebih
    //
    //    variables :
    //
    //    final createMasukInDateTime = DateTime.parse(create.masuk!);
    //    final openDateMax = DateTime(mstCuti.openDate!.year + 1, 6, 30);
    //
    /*     
        totalHariCutiTidakBaru =  mstCuti!.cutiTidakBaru! -
                                  tglAkhirInDateTime.difference(tglAwalInDateTime).inDays -
                                  jumlahhari -
                                  create.hitungLibur!;
    */

    final bool saldoCutiTidakBaruTidakCukup = totalHariCutiTidakBaru < 0;

    // 'Saldo Cuti Setelah Setahun Masuk (Tahun Masuk + 1)
    if (sayaCutiDiTahunMasukBerikutnya) {
      if (saldoCutiTidakBaruTidakCukup) {
        throw AssertionError(
            "Sisa Saldo Cuti Tidak Cukup! Saldo Cuti Anda Tersisa ${mstCuti.cutiTidakBaru} Untuk Periode ${mstCuti.tahunCutiTidakBaru}");
      }

      if (mstCuti.cutiTidakBaru! > 0 && tglStartLebihDariTglMasuk) {
        await ref.read(createCutiRepositoryProvider).resetCutiSatuTahunLebih(
            idUser: idUser, nama: nama, masuk: create.masuk!);
      }
    }

    // 5. Saldo Cuti Setelah Dua Tahun Masuk dan Seterusnya (Tahun Masuk + 2)
    //
    //
    //    Jika masa kerja user sudah 2 tahun atau lebih
    //
    //    variables :
    //
    //    final createMasukInDateTime = DateTime.parse(create.masuk!);
    //    final openDateMax = DateTime(mstCuti.openDate!.year + 1, 6, 30);
    //
    /*     
        totalHariCutiTidakBaru =  mstCuti!.cutiTidakBaru! -
                                  tglAkhirInDateTime.difference(tglAwalInDateTime).inDays -
                                  jumlahhari -
                                  create.hitungLibur!;
    */

    final DateTime openDateMax = DateTime(mstCuti.openDate!.year + 1, 6, 30);
    final bool tglStartLebihDariDateMax =
        tglAwalInDateTime.difference(openDateMax).isNegative == false;

    if (sayaCutiDiTahunMasuk && sayaCutiDiTahunMasukBerikutnya) {
      if (saldoCutiTidakBaruTidakCukup) {
        throw AssertionError(
            "Sisa Saldo Cuti Tidak Cukup! Saldo Cuti Anda Tersisa ${mstCuti.cutiTidakBaru} Untuk Periode ${mstCuti.tahunCutiTidakBaru}");
      }

      if (mstCuti.cutiTidakBaru! > 0 && tglStartLebihDariDateMax) {
        await ref.read(createCutiRepositoryProvider).resetCutiDuaTahunLebih(
            idUser: idUser, nama: nama, masuk: create.masuk!);
      }
    }
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

    // 2. CALC JUMLAH MASA KERJA, JIKA KURANG DARI 12 BULAN
    if (DateTime.now().difference(DateTime.parse(create.masuk!)).inDays < 365 &&
        isCutiEmergencyOrTahunan) {
      throw AssertionError(
          "Anda Belum Mendapat Hak Cuti, Masa Kerja Belum Setahun!");
    }
  }

  // dateMasuk, tahunCuti, tglAwaltglMasukDiff

  Future<void> _notHrCondition({
    required int jumlahhari,
    required String jenisCuti,
    required DateTime tglAwalInDateTime,
    required DateTime tglAkhirInDateTime,
  }) async {
    if (tglAwalInDateTime != tglAkhirInDateTime &&
        !tglAwalInDateTime.difference(tglAkhirInDateTime).isNegative) {
      throw AssertionError(
          'Tanggal Awal Tidak Boleh Lebih Besar Dari Tanggal Akhir');
    }

    if (DateTime.now().difference(tglAwalInDateTime).inDays - jumlahhari > 5 &&
        jenisCuti == 'CT') {
      throw AssertionError('Tanggal input lewat dari 5 hari');
    }
  }

  bool _isAct() {
    final server = ref.read(userNotifierProvider).user.ptServer;
    return server == 'gs_12';
  }

  bool isHrdOrSpv(String? access) {
    final special = ref.read(userNotifierProvider).user.fullAkses;

    if (access == null) {
      return false;
    }

    if (special == true) {
      return true;
    }
    // verify below,
    // in case have access

    if (_isAct()) {
      return access.contains('2,');
    } else {
      return access.contains('5101,');
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

  DateTime _returnDateMasuk({required DateTime createMasukInDateTime}) {
    // 1. Mendapatkan date Masuk untuk dikirim
    //    ke proses insert
    //

    //
    //    jika masuk saat bulan februari
    if (createMasukInDateTime.month == 2) {
      return DateTime(
          createMasukInDateTime.year + 2, createMasukInDateTime.month - 1, 28);
    }

    //
    //    jika masuk saat bulan januari
    else if (createMasukInDateTime.month == 1) {
      return DateTime(createMasukInDateTime.year + 1, 12, 31);
    } else {
      return DateTime(
          createMasukInDateTime.year + 2, createMasukInDateTime.month - 1, 30);
    }
  }

  String _returnTahunCuti(
      {required MstKaryawanCuti mstCuti, required int tglAwaltglMasukDiff}) {
    // 2. Mendapatkan tahun Cuti untuk dikirim
    //    ke proses insert
    //
    if (mstCuti.cutiBaru == 0 ||
        mstCuti.cutiBaru! > 0 && !tglAwaltglMasukDiff.isNegative) {
      return mstCuti.tahunCutiTidakBaru!;
    } else {
      return mstCuti.tahunCutiBaru!;
    }
  }
}
