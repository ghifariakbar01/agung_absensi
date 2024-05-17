import 'package:face_net_authentication/dt_pc/dt_pc_list/application/dt_pc_list_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../send_wa/application/phone_num.dart';
import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';

import '../../dt_pc_list/application/dt_pc_list.dart';

import '../infrastructures/dt_pc_approve_remote_service.dart.dart';
import '../infrastructures/dt_pc_approve_repository.dart';

part 'dt_pc_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
DtPcApproveRemoteService dtPcApproveRemoteService(
    DtPcApproveRemoteServiceRef ref) {
  return DtPcApproveRemoteService(
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
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
    final PhoneNum phoneNum = PhoneNum(
      noTelp1: itemDt.noTelp1,
      noTelp2: itemDt.noTelp2,
    );

    return ref.read(sendWaNotifierProvider.notifier).processAndSendWa(
        idUser: itemDt.idUser!,
        idDept: itemDt.idDept!,
        phoneNum: phoneNum,
        messageContent: messageContent);
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
    bool approveSpv = false;

    if (item.hrdSta == true) {
      approveSpv = false;
    }

    final spv = ref.read(userNotifierProvider).user.spv;
    if (ref.read(dtPcListControllerProvider.notifier).isHrdOrSpv(spv) ==
        false) {
      approveSpv = false;
    }

    final staff = ref.read(userNotifierProvider).user.staf!;
    if (staff.contains(item.idUser.toString()) == false) {
      approveSpv = false;
    }

    final int jumlahHari =
        DateTime.now().difference(DateTime.parse(item.cDate!)).inDays;

    final int jumlahHariLibur =
        calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now());

    if (jumlahHari - jumlahHariLibur >= 3) {
      approveSpv = false;
    }

    if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
      approveSpv = false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      approveSpv = true;
    }

    return approveSpv;
  }

  bool canHrdApprove(DtPcList item) {
    bool approveHrd = false;

    if (item.spvSta == false) {
      approveHrd = false;
    }

    final hrd = ref.read(userNotifierProvider).user.fin;
    if (ref.read(dtPcListControllerProvider.notifier).isHrdOrSpv(hrd) ==
        false) {
      approveHrd = false;
    }

    final int jumlahHari =
        DateTime.now().difference(DateTime.parse(item.spvTgl!)).inDays;

    final int jumlahHariLibur =
        calcDiffSaturdaySunday(DateTime.parse(item.spvTgl!), DateTime.now());

    if (jumlahHari - jumlahHariLibur >= 1) {
      approveHrd = false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      approveHrd = true;
    }

    return approveHrd;
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
