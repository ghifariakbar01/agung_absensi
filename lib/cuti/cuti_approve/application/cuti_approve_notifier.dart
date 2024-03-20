import 'dart:developer';

import 'package:face_net_authentication/cuti/create_cuti/application/create_cuti_notifier.dart';
import 'package:face_net_authentication/cuti/cuti_approve/infrastructure/cuti_approve_remote_service.dart.dart';
import 'package:face_net_authentication/sakit/create_sakit/application/create_sakit_notifier.dart';
import 'package:face_net_authentication/send_wa/application/phone_num.dart';
import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti_notifier.dart';
import '../../../sakit/create_sakit/application/create_sakit.dart';

import '../../../shared/providers.dart';

import '../../cuti_list/application/cuti_list.dart';

import '../infrastructure/cuti_approve_repository.dart';

part 'cuti_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
CutiApproveRemoteService cutiApproveRemoteService(
    CutiApproveRemoteServiceRef ref) {
  return CutiApproveRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CutiApproveRepository cutiApproveRepository(CutiApproveRepositoryRef ref) {
  return CutiApproveRepository(
    ref.watch(cutiApproveRemoteServiceProvider),
  );
}

@riverpod
class CutiApproveController extends _$CutiApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> _sendWa(
      {required CutiList itemCuti, required String messageContent}) async {
    final PhoneNum phoneNum = PhoneNum(
      noTelp1: itemCuti.noTelp1,
      noTelp2: itemCuti.noTelp2,
    );

    return ref.read(sendWaNotifierProvider.notifier).processAndSendWa(
        idUser: itemCuti.idUser!,
        idDept: itemCuti.idDept!,
        phoneNum: phoneNum,
        messageContent: messageContent);
  }

  Future<void> approveSpv({
    required String nama,
    required String note,
    required CutiList itemCuti,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(cutiApproveRepositoryProvider)
          .approveSpv(nama: nama, note: note, idCuti: itemCuti.idCuti!);
      final String messageContent =
          ' (Testing Apps) Izin Sakit Anda Sudah Diapprove Oleh Atasan $nama ';
      await _sendWa(itemCuti: itemCuti, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Cuti');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unapproveSpv({
    required String nama,
    required CutiList itemCuti,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(cutiApproveRepositoryProvider)
          .unapproveSpv(nama: nama, idCuti: itemCuti.idCuti!);

      state = AsyncData<void>('Sukses Melakukan Unapprove Form Cuti');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> approveHrd({
    required String nama,
    required String note,
    required CutiList itemCuti,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      if (itemCuti.jenisCuti != 'CR') {
        final CreateSakit create = await ref
            .read(createSakitNotifierProvider.notifier)
            .getCreateSakit(
                itemCuti.idUser!, itemCuti.tglStart!, itemCuti.tglEnd!);
        final MstKaryawanCuti mstCuti = await ref
            .read(mstKaryawanCutiNotifierProvider.notifier)
            .getSaldoMasterCutiById(itemCuti.idUser!);

        final DateTime? dateMasuk = _returnDateMasuk(
            createMasukInDateTime: DateTime.parse(create.masuk!));

        final sayaCutiDiTahunYangSama = int.parse(itemCuti.tahunCuti!) ==
            DateTime.parse(create.masuk!).year;
        final sayaCutiDiTahunBerikutnya = int.parse(itemCuti.tahunCuti!) ==
            DateTime.parse(create.masuk!).year + 1;
        final tidakAdaCutiBaruDan =
            mstCuti.cutiBaru == 0 && !sayaCutiDiTahunYangSama;

        final sayaCutiSaatMasuk = DateTime.parse(itemCuti.tglStart!)
            .difference(dateMasuk!)
            .isNegative;
        final adaCutiBaruDan = mstCuti.cutiBaru! > 0 &&
            !sayaCutiSaatMasuk &&
            !sayaCutiDiTahunYangSama;

        // calc sisa cuti
        if (itemCuti.hrdNm == null) {
          await ref
              .read(cutiApproveRepositoryProvider)
              .calcSisaCuti(itemCuti: itemCuti);
        }

        // calc cuti_tidak_baru OR cuti_baru
        if (tidakAdaCutiBaruDan || adaCutiBaruDan) {
          // update
          // cuti_tidak_baru
          await ref.read(cutiApproveRepositoryProvider).calcCutiTidakBaru(
              totalHari: itemCuti.totalHari!, mstCuti: mstCuti);

          //
        } else if (sayaCutiDiTahunYangSama && sayaCutiSaatMasuk) {
          // update
          // cuti_baru
          await ref
              .read(cutiApproveRepositoryProvider)
              .calcCutiBaru(totalHari: itemCuti.totalHari!, mstCuti: mstCuti);
          //
        }

        final cutiBaruSayaHabis = mstCuti.cutiBaru! - itemCuti.totalHari! == 0;
        final cutiTidakBaruSayaHabis =
            mstCuti.cutiTidakBaru! - itemCuti.totalHari! == 0;

        // calc close_date, open_date, cuti_tidak_baru, tahun_cuti_tidak_baru
        if (sayaCutiDiTahunYangSama && cutiBaruSayaHabis) {
          // update
          // close_date
          // open_date

          await ref
              .read(cutiApproveRepositoryProvider)
              .calcCloseOpenDate(masuk: create.masuk!, mstCuti: mstCuti);
          //
        } else if (sayaCutiDiTahunYangSama && cutiTidakBaruSayaHabis) {
          // update
          // cuti_tidak_baru
          // tahun_cuti_tidak_baru
          // close_date
          // open_date

          await ref
              .read(cutiApproveRepositoryProvider)
              .calcCloseOpenCutiTidakBaruDanTahuCuti(
                  masuk: create.masuk!, mstCuti: mstCuti);
          //
        } else if (!sayaCutiDiTahunYangSama && cutiTidakBaruSayaHabis ||
            sayaCutiDiTahunBerikutnya) {
          // update
          // cuti_tidak_baru
          // close_date
          // open_date

          await ref
              .read(cutiApproveRepositoryProvider)
              .calcCloseOpenCutiTidakBaruDanTahuCuti2(
                mstCuti: mstCuti,
              );
          //
        }
      }

      final String messageContent =
          'Izin Sakit Anda Sudah Diapprove Oleh HRD $nama';
      await _sendWa(itemCuti: itemCuti, messageContent: messageContent);

      await ref.read(cutiApproveRepositoryProvider).approveHrd(
            nama: nama,
            note: note,
            itemCuti: itemCuti,
          );

      return Future.value('Sukses Melakukan Approve Form Cuti');
    });
  }

  Future<void> unapproveHrd({
    required String nama,
    required CutiList itemCuti,
  }) async {
    state = const AsyncLoading();

    try {
      // jika bukan cuti roster
      if (itemCuti.jenisCuti != 'CR') {
        final CreateSakit create = await ref
            .read(createSakitNotifierProvider.notifier)
            .getCreateSakit(
                itemCuti.idUser!, itemCuti.tglStart!, itemCuti.tglEnd!);
        final MstKaryawanCuti mstCuti = await ref
            .read(mstKaryawanCutiNotifierProvider.notifier)
            .getSaldoMasterCutiById(itemCuti.idUser!);

        final DateTime? dateMasuk = _returnDateMasuk(
            createMasukInDateTime: DateTime.parse(create.masuk!));

        final sayaCutiDiTahunYangSama = int.parse(itemCuti.tahunCuti!) ==
            DateTime.parse(create.masuk!).year;
        final tidakAdaCutiBaruDan =
            mstCuti.cutiBaru == 0 && !sayaCutiDiTahunYangSama;

        final sayaCutiSaatMasuk = DateTime.parse(itemCuti.tglStart!)
            .difference(dateMasuk!)
            .isNegative;
        final adaCutiBaruDan = mstCuti.cutiBaru! > 0 &&
            !sayaCutiSaatMasuk &&
            !sayaCutiDiTahunYangSama;

        // calc sisa cuti
        if (itemCuti.hrdNm == null) {
          await ref
              .read(cutiApproveRepositoryProvider)
              .calcSisaCuti(isRestore: true, itemCuti: itemCuti);
        }

        // calc cuti_tidak_baru OR cuti_baru
        if (tidakAdaCutiBaruDan || adaCutiBaruDan) {
          // update
          // cuti_tidak_baru
          await ref.read(cutiApproveRepositoryProvider).calcCutiTidakBaru(
                isRestore: true,
                totalHari: itemCuti.totalHari!,
                mstCuti: mstCuti,
              );

          //
        } else if (sayaCutiDiTahunYangSama && sayaCutiSaatMasuk) {
          // update
          // cuti_baru
          await ref.read(cutiApproveRepositoryProvider).calcCutiBaru(
              isRestore: true,
              totalHari: itemCuti.totalHari!,
              mstCuti: mstCuti);
          //
        }
      }

      await ref.read(cutiApproveRepositoryProvider).unapproveHrd(
            nama: nama,
            itemCuti: itemCuti,
          );

      state = AsyncData<void>('Sukses Melakukan Unapprove Form Cuti');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> batal({
    required String nama,
    required CutiList itemCuti,
  }) async {
    state = const AsyncLoading();

    try {
      // jika bukan cuti roster
      if (itemCuti.jenisCuti != 'CR') {
        final CreateSakit create = await ref
            .read(createSakitNotifierProvider.notifier)
            .getCreateSakit(
                itemCuti.idUser!, itemCuti.tglStart!, itemCuti.tglEnd!);
        final MstKaryawanCuti mstCuti = await ref
            .read(mstKaryawanCutiNotifierProvider.notifier)
            .getSaldoMasterCutiById(itemCuti.idUser!);

        final DateTime? dateMasuk = _returnDateMasuk(
            createMasukInDateTime: DateTime.parse(create.masuk!));

        final sayaCutiDiTahunYangSama = int.parse(itemCuti.tahunCuti!) ==
            DateTime.parse(create.masuk!).year;
        final tidakAdaCutiBaruDan =
            mstCuti.cutiBaru == 0 && !sayaCutiDiTahunYangSama;

        final sayaCutiSaatMasuk = DateTime.parse(itemCuti.tglStart!)
            .difference(dateMasuk!)
            .isNegative;
        final adaCutiBaruDan = mstCuti.cutiBaru! > 0 &&
            !sayaCutiSaatMasuk &&
            !sayaCutiDiTahunYangSama;

        if (itemCuti.sisaCuti == 0 && !sayaCutiDiTahunYangSama) {
          throw AssertionError('Sisa Cuti Tidak Ada');
        }

        if (itemCuti.spvSta == false && itemCuti.hrdSta == false) {
          throw AssertionError('Belum diapprove Spv & Hrd');
        }

        // calc sisa cuti
        if (itemCuti.hrdNm == null) {
          await ref
              .read(cutiApproveRepositoryProvider)
              .calcSisaCuti(isRestore: true, itemCuti: itemCuti);
        }

        // calc cuti_tidak_baru OR cuti_baru
        if (tidakAdaCutiBaruDan || adaCutiBaruDan) {
          // update
          // cuti_tidak_baru
          await ref.read(cutiApproveRepositoryProvider).calcCutiTidakBaru(
                isRestore: true,
                totalHari: itemCuti.totalHari!,
                mstCuti: mstCuti,
              );

          //
        } else if (sayaCutiDiTahunYangSama && sayaCutiSaatMasuk) {
          // update
          // cuti_baru
          await ref.read(cutiApproveRepositoryProvider).calcCutiBaru(
              isRestore: true,
              totalHari: itemCuti.totalHari!,
              mstCuti: mstCuti);
          //
        }
      }

      debugger();

      await ref.read(cutiApproveRepositoryProvider).batal(
            nama: nama,
            itemCuti: itemCuti,
          );

      final String messageContent =
          ' (Testing Apps) Izin Cuti Anda Telah Di Batalkan Oleh : $nama ';
      await _sendWa(itemCuti: itemCuti, messageContent: messageContent);

      debugger();

      state = AsyncData<void>('Sukses Membatalkan Form Cuti');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
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

  Future<bool> canSpvApprove(CutiList item) async {
    bool approveSpv = false;

    if (item.hrdSta == true) {
      approveSpv = false;
    }

    final spv = ref.read(userNotifierProvider).user.spv;
    if (ref.read(createCutiNotifierProvider.notifier).isHrdOrSpv(spv) ==
        false) {
      approveSpv = false;
    }

    if (item.jenisCuti != 'CR') {
      final int jumlahHari =
          DateTime.now().difference(DateTime.parse(item.cDate!)).inDays;

      final int jumlahHariLibur =
          calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now());

      final CreateSakit createSakit = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(item.idUser!, item.tglStart!, item.tglEnd!);

      final staff = ref.read(userNotifierProvider).user.staf!;
      if (staff.contains(item.idUser.toString()) == false) {
        approveSpv = false;
      }

      if (jumlahHari - jumlahHariLibur - createSakit.hitungLibur! >= 3 &&
          item.jenisCuti == 'CT') {
        approveSpv = false;
      }
    }

    if (item.idUser == ref.read(userNotifierProvider).user.idUser) {
      approveSpv = false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      approveSpv = true;
    }

    return approveSpv;
  }

  Future<bool> canHrdApprove(CutiList item) async {
    bool approveHrd = false;

    if (item.spvSta == false) {
      approveHrd = false;
    }

    final user = ref.read(userNotifierProvider).user;
    if (ref.read(createCutiNotifierProvider.notifier).isHrdOrSpv(user.fin) ==
        false) {
      approveHrd = false;
    }

    if (item.jenisCuti != 'CR') {
      final int jumlahHari =
          DateTime.now().difference(DateTime.parse(item.cDate!)).inDays;

      final int jumlahHariLibur =
          calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now());

      final CreateSakit createSakit = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(item.idUser!, item.tglStart!, item.tglEnd!);

      if (jumlahHari - jumlahHariLibur - createSakit.hitungLibur! >= 1 &&
          item.jenisCuti == 'CT') {
        approveHrd = false;
      }
    }

    if (user.fullAkses == true) {
      approveHrd = true;
    }

    if (item.jenisCuti != 'CR') {
      final MstKaryawanCuti mstCuti = await ref
          .read(mstKaryawanCutiNotifierProvider.notifier)
          .getSaldoMasterCutiById(user.idUser!);

      if (item.hrdSta == true &&
          mstCuti.openDate!.year != int.parse(item.tahunCuti!)) {
        approveHrd = false;
      }
    }

    return approveHrd;
  }

  Future<bool> canBatal(CutiList item) async {
    bool approveBatal = false;

    if (item.btlSta == false) {
      approveBatal = true;
    }

    if (item.jenisCuti == 'CR') {
      final MstKaryawanCuti mstCuti = await ref
          .read(mstKaryawanCutiNotifierProvider.notifier)
          .getSaldoMasterCutiById(item.idUser!);
      if (mstCuti.openDate!.year.toString() != item.tahunCuti) {
        approveBatal = false;
      }
    }

    return approveBatal;
  }
}

// Future<void> unapproveSpv({
//   required String nama,
//   required SakitList itemSakit,
// }) async {
//   state = const AsyncLoading();

//   try {
//     final String messageContent =
//         'Izin Sakit Anda Sudah Diapprove Oleh Atasan $nama';

//     await _sendWa(itemSakit: itemSakit, messageContent: messageContent);
//     await ref
//         .read(cutiApproveRepositoryProvider)
//         .unapproveSpv(nama: nama, itemSakit: itemSakit);

//     state = AsyncData<void>('Sukses Unapprove Form Cuti');
//   } catch (e) {
//     state = AsyncError(e, StackTrace.current);
//   }
// }

// Future<void> unApproveHrdTanpaSurat({
//   required String nama,
//   required SakitList itemSakit,
//   required CreateSakit createSakit,
// }) async {
//   state = const AsyncLoading();

//   try {
//     await ref.read(cutiApproveRepositoryProvider).unApproveHrdTanpaSurat(
//         nama: nama, itemSakit: itemSakit, createSakit: createSakit);

//     state = AsyncData<void>('Sukses Unapprove Form Cuti');
//   } catch (e) {
//     state = AsyncError(e, StackTrace.current);
//   }
// }

// Future<void> batal({
//   required String nama,
//   required SakitList itemSakit,
// }) async {
//   state = const AsyncLoading();

//   try {
//     final String messageContent =
//         'Izin Sakit Anda Telah Di Batalkan Oleh : $nama';

//     await _sendWa(itemSakit: itemSakit, messageContent: messageContent);
//     await ref.read(cutiApproveRepositoryProvider).batal(
//           nama: nama,
//           itemSakit: itemSakit,
//         );

//     state = AsyncData<void>('Sukses Membatalkan Form Cuti');
//   } catch (e) {
//     state = AsyncError(e, StackTrace.current);
//   }
// }
