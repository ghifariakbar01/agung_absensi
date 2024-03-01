import 'package:face_net_authentication/dt_pc/dt_pc_list/application/dt_pc_list_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../send_wa/application/phone_num.dart';
import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';

import '../../dt_pc_list/application/dt_pc_list.dart';

import '../infrastructure/dt_pc_approve_remote_service.dart.dart';
import '../infrastructure/dt_pc_approve_repository.dart';

part 'dt_pc_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
DtPcApproveRemoteService dtPcApproveRemoteService(
    DtPcApproveRemoteServiceRef ref) {
  return DtPcApproveRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
DtPcApproveRepository dtPcApproveRepository(DtPcApproveRepositoryRef ref) {
  return DtPcApproveRepository(
    ref.watch(dtPcApproveRemoteServiceProvider),
  );
}

@riverpod
class DtPcApproveController extends _$DtPcApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> _sendWa(
      {required DtPcList itemDt, required String messageContent}) async {
    final PhoneNum registeredWa = PhoneNum(
      noTelp1: itemDt.noTelp1,
      noTelp2: itemDt.noTelp2,
    );

    if (registeredWa.noTelp1!.isNotEmpty) {
      await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
          phone: int.parse(registeredWa.noTelp1!),
          idUser: itemDt.idUser!,
          idDept: itemDt.idDept!,
          notifTitle: 'Notifikasi HRMS',
          notifContent: '$messageContent');
    } else if (registeredWa.noTelp2!.isNotEmpty) {
      await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
          phone: int.parse(registeredWa.noTelp2!),
          idUser: itemDt.idUser!,
          idDept: itemDt.idDept!,
          notifTitle: 'Notifikasi HRMS',
          notifContent: '$messageContent');
    } else {
      throw AssertionError(
          'User yang dituju tidak memiliki nomor telfon. Silahkan hubungi HR ');
    }
  }

  Future<void> approveSpv({
    required String nama,
    required DtPcList itemDt,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(dtPcApproveRepositoryProvider)
          .approveSpv(nama: nama, idDt: itemDt.idDt!);
      final String messageContent =
          'Izin DT/PC Anda Sudah Diapprove Oleh Atasan $nama';
      await _sendWa(itemDt: itemDt, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form DT/PC');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveSpv({
    required String nama,
    required DtPcList itemDt,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(dtPcApproveRepositoryProvider)
          .unApproveSpv(nama: nama, idDt: itemDt.idDt!);

      state = AsyncData<void>('Sukses Unapprove Form DT/PC');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> approveHrd({
    required String namaHrd,
    required String note,
    required DtPcList itemDt,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(dtPcApproveRepositoryProvider)
          .approveHrd(namaHrd: namaHrd, note: note, idDt: itemDt.idDt!);

      final String messageContent =
          'Izin DT/PC Anda Sudah Diapprove Oleh HRD $namaHrd';
      await _sendWa(itemDt: itemDt, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form DT/PC');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveHrd({
    required String namaHrd,
    required String note,
    required int idDt,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(dtPcApproveRepositoryProvider)
          .unApproveHrd(nama: namaHrd, note: note, idDt: idDt);

      state = AsyncData<void>('Sukses Melakukan Unapprove Form DT/PC');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> batal({
    required String nama,
    required DtPcList itemDt,
  }) async {
    state = const AsyncLoading();

    try {
      await ref.read(dtPcApproveRepositoryProvider).batal(
            nama: nama,
            idDt: itemDt.idDt!,
          );
      final String messageContent = 'Izin Anda Telah Di Batalkan Oleh : $nama';

      await _sendWa(itemDt: itemDt, messageContent: messageContent);
      state = AsyncData<void>('Sukses Membatalkan Form DT/PC');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  bool canSpvApprove(DtPcList item) {
    if (item.hrdSta == true) {
      return false;
    }

    final spv = ref.read(userNotifierProvider).user.spv;
    if (ref.read(dtPcListControllerProvider.notifier).isHrdOrSpv(spv) ==
        false) {
      return false;
    }

    final int jumlahHari =
        DateTime.now().difference(DateTime.parse(item.cDate!)).inDays;

    final int jumlahHariLibur =
        calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now());

    if (jumlahHari - jumlahHariLibur >= 3) {
      return false;
    }

    if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
      return false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      return true;
    }

    return false;
  }

  bool canHrdApprove(DtPcList item) {
    if (item.spvSta == false) {
      return false;
    }

    final hrd = ref.read(userNotifierProvider).user.fin;
    if (ref.read(dtPcListControllerProvider.notifier).isHrdOrSpv(hrd) ==
        false) {
      return false;
    }

    final int jumlahHari =
        DateTime.now().difference(DateTime.parse(item.spvTgl!)).inDays;

    final int jumlahHariLibur =
        calcDiffSaturdaySunday(DateTime.parse(item.spvTgl!), DateTime.now());

    if (jumlahHari - jumlahHariLibur >= 1) {
      return false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      return true;
    }

    return false;
  }

  bool canBatal(DtPcList item) {
    if (item.btlSta == true || item.hrdSta == true) {
      return false;
    }

    return true;
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
}
