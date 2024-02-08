import 'dart:developer';

import 'package:face_net_authentication/cuti/cuti_approve/infrastructure/cuti_approve_remote_service.dart.dart';
import 'package:face_net_authentication/sakit/create_sakit/application/create_sakit_notifier.dart';
import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:face_net_authentication/wa_register/application/wa_register_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../sakit/create_sakit/application/create_sakit.dart';
import '../../../shared/providers.dart';
import '../../../wa_register/application/wa_register.dart';

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
    debugger();

    final WaRegister registeredWa = await ref
        .read(waRegisterNotifierProvider.notifier)
        .getCurrentRegisteredWa();

    if (registeredWa.phone != null) {
      //
      await ref.read(sendWaNotifierProvider.notifier).sendWa(
          phone: int.parse(registeredWa.phone!),
          idUser: itemCuti.idUser!,
          // idDept: itemCuti.idDept!,
          idDept: 1,
          notifTitle: 'Notifikasi HRMS',
          notifContent: '$messageContent');
    } else {
      //
      throw AssertionError(
          'Phone number not Registerd. Daftarkan dahulu nomor Wa Anda di Home');
    }
  }

  Future<void> approveSpv({
    required String nama,
    required String note,
    required CutiList itemCuti,
  }) async {
    state = const AsyncLoading();

    try {
      final String messageContent =
          'Izin Sakit Anda Sudah Diapprove Oleh Atasan $nama';

      await _sendWa(itemCuti: itemCuti, messageContent: messageContent);
      await ref
          .read(cutiApproveRepositoryProvider)
          .approveSpv(nama: nama, note: note, idCuti: itemCuti.idCuti!);

      state = AsyncData<void>('Sukses Melakukan Approve Form Sakit');
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

    try {
      final String messageContent =
          'Izin Sakit Anda Sudah Diapprove Oleh HRD $nama';

      await _sendWa(itemCuti: itemCuti, messageContent: messageContent);
      await ref.read(cutiApproveRepositoryProvider).approveHrd(
            nama: nama,
            note: note,
            itemCuti: itemCuti,
          );

      // calc saldo cuti
      // 1. get date masuk
      final CreateSakit create = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(ref.read(userNotifierProvider).user,
              itemCuti.tglStart!, itemCuti.tglEnd!);
      final DateTime? dateMasuk = _returnDateMasuk(
          createMasukInDateTime: DateTime.parse(create.masuk!));

      final sayaCutiDiTahunYangSama =
          int.parse(itemCuti.tahunCuti!) == DateTime.parse(create.masuk!).year;
      final sayaCutiDiTahunBerikutnya = int.parse(itemCuti.tahunCuti!) ==
          DateTime.parse(create.masuk!).year + 1;
      final tidakAdaCutiBaruDan =
          create.createSakitCuti!.cutiBaru == 0 && !sayaCutiDiTahunYangSama;

      final sayaCutiSaatMasuk =
          DateTime.parse(itemCuti.tglStart!).difference(dateMasuk!).isNegative;
      final adaCutiBaruDan = create.createSakitCuti!.cutiBaru! > 0 &&
          !sayaCutiSaatMasuk &&
          !sayaCutiDiTahunYangSama;

      // 2. jika cuti baru = 0
      if (tidakAdaCutiBaruDan || adaCutiBaruDan) {
        // update
        // cuti_tidak_baru

        //
      } else if (sayaCutiDiTahunYangSama && sayaCutiSaatMasuk) {
        // update
        // cuti_baru

        //
      }

      final cutiBaruSayaHabis =
          create.createSakitCuti!.cutiBaru! - itemCuti.totalHari! == 0;

      final cutiTidakBaruSayaHabis =
          create.createSakitCuti!.cutiTidakBaru! - itemCuti.totalHari! == 0;

      if (sayaCutiDiTahunYangSama && cutiBaruSayaHabis) {
        // update
        // close_date
        // open_date

        //
      } else if (sayaCutiDiTahunYangSama && cutiTidakBaruSayaHabis) {
        // update
        // cuti_tidak_baru
        // tahun_cuti_tidak_baru
        // close_date
        // open_date

        //
      } else if (!sayaCutiDiTahunYangSama && cutiTidakBaruSayaHabis ||
          sayaCutiDiTahunBerikutnya) {
        // update
        // cuti_tidak_baru
        // open_date
        // close_date

        //
      }

      state = AsyncData<void>('Sukses Melakukan Approve Form Sakit');
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
    if (item.hrdSta == true) {
      return false;
    }

    final user = ref.read(userNotifierProvider).user;

    if (user.isSpvOrHrd == false) {
      return false;
    }

    if (user.idUser == item.idUser) {
      return false;
    }

    final int jumlahHari =
        DateTime.parse(item.cDate!).difference(DateTime.now()).inDays;

    final int jumlahHariLibur =
        calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now());

    final CreateSakit createSakit = await ref
        .read(createSakitNotifierProvider.notifier)
        .getCreateSakit(user, item.tglStart!, item.tglEnd!);

    if (jumlahHari - jumlahHariLibur - createSakit.hitungLibur! >= 3 &&
        item.jenisCuti == 'CT') {
      return false;
    }

    if (user.fullAkses == true) {
      return true;
    }

    return false;
  }

  Future<bool> canHrdApprove(CutiList item) async {
    if (item.spvSta == false) {
      return false;
    }

    final user = ref.read(userNotifierProvider).user;

    if (item.hrdSta == true) {
      return false;
    }

    if (user.isSpvOrHrd == false) {
      return false;
    }

    if (user.idUser == item.idUser) {
      return false;
    }

    if (calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now()) >=
        1) {
      return false;
    }

    if (user.fullAkses == true) {
      return true;
    }

    final int jumlahHari =
        DateTime.parse(item.cDate!).difference(DateTime.now()).inDays;

    final int jumlahHariLibur =
        calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now());

    final CreateSakit createSakit = await ref
        .read(createSakitNotifierProvider.notifier)
        .getCreateSakit(user, item.tglStart!, item.tglEnd!);

    if (jumlahHari - jumlahHariLibur - createSakit.hitungLibur! >= 3 &&
        item.jenisCuti == 'CT') {
      return false;
    }

    if (item.jenisCuti != 'CR') {
      if (createSakit.createSakitCuti!.openDate!.year.toString() !=
          item.tahunCuti) {
        return false;
      }
    }

    return false;
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

  //     state = AsyncData<void>('Sukses Unapprove Form Sakit');
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

  //     state = AsyncData<void>('Sukses Unapprove Form Sakit');
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

  //     state = AsyncData<void>('Sukses Membatalkan Form Sakit');
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //   }
  // }