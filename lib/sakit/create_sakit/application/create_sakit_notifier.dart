import 'package:face_net_authentication/application/user/user_model.dart';
import 'package:face_net_authentication/sakit/create_sakit/application/create_sakit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
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

    int jumlahhari = 0;

    try {
      final CreateSakit create = await getCreateSakit(user, tglAwal, tglAkhir);

      await _processSakit(
          create: create,
          user: user,
          onError: onError,
          tglAwal: tglAwal,
          tglAkhir: tglAkhir,
          jumlahhari: jumlahhari,
          suratDokter: suratDokter);

      state = await AsyncValue.guard(() => repo.submitSakit(
          idUser: user.idUser!,
          ket: keterangan,
          surat: suratDokter,
          cUser: user.nama!,
          tglEnd: tglAkhir,
          tglStart: tglAwal,
          jumlahHari: jumlahhari.toString()));
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

    int jumlahhari = 0;

    try {
      final CreateSakit create = await getCreateSakit(user, tglAwal, tglAkhir);

      await _processSakit(
          create: create,
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
          surat: suratDokter,
          cUser: user.nama!,
          tglEnd: tglAkhir,
          tglStart: tglAwal,
          jumlahHari: jumlahhari,
          hitungLibur: create.hitungLibur ?? 0));
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
    //
    required int jumlahhari,
    required String tglAwal,
    required String tglAkhir,
    required String suratDokter,
    required UserModelWithPassword user,
    required Future<void> onError(String errMessage),
  }) async {
    // 1. CALC JUMLAH HARI

    final tglAwalInDateTime = DateTime.parse(tglAwal);
    final tglAkhirInDateTime = DateTime.parse(tglAkhir);

    // jumlahhari MUTATION
    _calcDiff(create, jumlahhari, tglAwalInDateTime, tglAkhirInDateTime);

    // JIKA TS
    if (suratDokter == 'TS') {
      await _noSuratCondition(create);
    }

    // SALDO CUTI
    await _calcSaldoCuti(
      create: create,
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

    final openDate = create.createSakitCuti!.openDate;
    final closeDateInDateTime = create.createSakitCuti!.closeDate!;

    final jumlahCutiTidakBaru = create.createSakitCuti!.cutiTidakBaru!;
    final diffSinceOpenDate = DateTime.now().difference(openDate!).inDays;

    final isSameYear = tglAwalInDateTime.year != createMasukInDateTime.year ||
        tglAwalInDateTime.year != createMasukInDateTimePlusOne.year;

    if (jumlahCutiTidakBaru > 0 &&
        isSameYear &&
        suratDokter == 'TS' &&
        diffSinceOpenDate > 0) {
      throw AssertionError(
          " Saldo Cuti ${closeDateInDateTime.year} Habis! Belum Masuk Periode Cuti ${create.createSakitCuti!.tahunCutiTidakBaru} ");
    }

    final cutiBaru = create.createSakitCuti!.cutiBaru!;
    final startEndPlusOneDiffInDays = tglAwalInDateTime
        .difference(tglAkhirInDateTime.add(Duration(days: 1)))
        .inDays;

    if (cutiBaru > 0 && suratDokter == 'TS') {
      if (cutiBaru -
              startEndPlusOneDiffInDays -
              jumlahhari -
              create.hitungLibur! <
          0) {
        throw AssertionError("Sisa Saldo Cuti Tidak Cukup! " +
            " Saldo Cuti Anda Tersisa $cutiBaru  Untuk Periode ${create.createSakitCuti!.tahunCutiBaru} ");
      }
    }

    final cutiTidakBaru = create.createSakitCuti!.cutiTidakBaru!;

    if (cutiTidakBaru -
            startEndPlusOneDiffInDays -
            jumlahhari -
            create.hitungLibur! <
        0) {
      throw AssertionError("Sisa Saldo Cuti Tidak Cukup! " +
          " Saldo Cuti Anda Tersisa $cutiTidakBaru  Untuk Periode ${create.createSakitCuti!.tahunCutiTidakBaru} ");
    }
  }

  Future<void> _noSuratCondition(
    CreateSakit create,
  ) async {
    //
    // 2. CALC JUMLAH HARI LIBUR
    if (create.hitungLibur == 0) {
      throw AssertionError(
          "Master Data Cuti Anda Belum Ada! Silahkan Hubungi HR");
    }
    //
    // 3. CALC JUMLAH MASA KERJA, JIKA KURANG DARI 12 BULAN
    if (DateTime.parse('${create.masuk}').difference(DateTime.now()).inDays <
        365) {
      throw AssertionError(
          "Anda Belum Mendapat Hak Cuti, Masa Kerja Belum Setahun!");
    }
  }
}

void _calcDiff(CreateSakit create, int jumlahhari, DateTime tglAwalInDateTime,
    DateTime tglAkhirInDateTime) {
  if (create.jadwalSabtu!.isNotEmpty && create.bulanan == false) {
    jumlahhari = calcDiffSaturdaySunday(tglAwalInDateTime, tglAkhirInDateTime);
  } else if (create.jadwalSabtu!.isEmpty || create.bulanan == true) {
    jumlahhari = calcDiffSunday(tglAwalInDateTime, tglAkhirInDateTime);
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
