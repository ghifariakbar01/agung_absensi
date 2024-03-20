import 'package:face_net_authentication/izin/izin_approve/infrastructure/izin_approve_repository.dart';
import 'package:face_net_authentication/izin/izin_list/application/izin_list_notifier.dart';
import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../send_wa/application/phone_num.dart';
import '../../../shared/providers.dart';

import '../../izin_list/application/izin_list.dart';

import '../infrastructure/izin_approve_remote_service.dart.dart';

part 'izin_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
IzinApproveRemoteService izinApproveRemoteService(
    IzinApproveRemoteServiceRef ref) {
  return IzinApproveRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
IzinApproveRepository izinApproveRepository(IzinApproveRepositoryRef ref) {
  return IzinApproveRepository(
    ref.watch(izinApproveRemoteServiceProvider),
  );
}

@riverpod
class IzinApproveController extends _$IzinApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> _sendWa(
      {required IzinList itemIzin, required String messageContent}) async {
    final PhoneNum phoneNum = PhoneNum(
      noTelp1: itemIzin.noTelp1,
      noTelp2: itemIzin.noTelp2,
    );

    return ref.read(sendWaNotifierProvider.notifier).processAndSendWa(
        idUser: itemIzin.idUser!,
        idDept: itemIzin.idDept!,
        phoneNum: phoneNum,
        messageContent: messageContent);
  }

  Future<void> approveSpv({
    required String nama,
    required IzinList itemIzin,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(izinApproveRepositoryProvider)
          .approveSpv(nama: nama, idIzin: itemIzin.idIzin!);
      final String messageContent =
          'Izin Anda Sudah Diapprove Oleh Atasan $nama';
      await _sendWa(itemIzin: itemIzin, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Izin');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveSpv({
    required String nama,
    required IzinList itemIzin,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(izinApproveRepositoryProvider)
          .unApproveSpv(nama: nama, idIzin: itemIzin.idIzin!);

      state = AsyncData<void>('Sukses Unapprove Form Izin');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> approveHrd({
    required String namaHrd,
    required String note,
    required IzinList itemIzin,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(izinApproveRepositoryProvider)
          .approveHrd(namaHrd: namaHrd, note: note, idIzin: itemIzin.idIzin!);

      final String messageContent =
          'Izin Anda Sudah Diapprove Oleh HRD $namaHrd';
      await _sendWa(itemIzin: itemIzin, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Izin');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveHrd({
    required String namaHrd,
    required String note,
    required int idIzin,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(izinApproveRepositoryProvider)
          .unApproveHrd(nama: namaHrd, note: note, idIzin: idIzin);

      state = AsyncData<void>('Sukses Melakukan Unapprove Form Izin');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> batal({
    required String nama,
    required IzinList itemIzin,
  }) async {
    state = const AsyncLoading();

    try {
      await ref.read(izinApproveRepositoryProvider).batal(
            nama: nama,
            idIzin: itemIzin.idIzin!,
          );
      final String messageContent = 'Izin Anda Telah Di Batalkan Oleh : $nama';

      await _sendWa(itemIzin: itemIzin, messageContent: messageContent);
      state = AsyncData<void>('Sukses Membatalkan Form Izin');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  bool canSpvApprove(IzinList item) {
    bool approveSpv = false;

    if (item.hrdSta == true) {
      approveSpv = false;
    }

    final spv = ref.read(userNotifierProvider).user.spv;
    if (ref.read(izinListControllerProvider.notifier).isHrdOrSpv(spv) ==
        false) {
      approveSpv = false;
    }

    final staff = ref.read(userNotifierProvider).user.staf!;
    if (staff.contains(item.idUser.toString()) == false) {
      approveSpv = false;
    }

    final jumlahHari =
        calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now());
    final dateDiff =
        DateTime.now().difference(DateTime.parse(item.cDate!)).inDays;

    if (dateDiff - jumlahHari >= 3) {
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

  bool canHrdApprove(IzinList item) {
    bool approveHrd = false;

    if (item.spvSta == false) {
      approveHrd = false;
    }

    final hrd = ref.read(userNotifierProvider).user.fin;

    if (ref.read(izinListControllerProvider.notifier).isHrdOrSpv(hrd) ==
        false) {
      approveHrd = false;
    }

    final jumlahHari =
        calcDiffSaturdaySunday(DateTime.parse(item.spvTgl!), DateTime.now());
    final dateDiff =
        DateTime.now().difference(DateTime.parse(item.spvTgl!)).inDays;

    if (dateDiff - jumlahHari >= 1) {
      approveHrd = false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      approveHrd = true;
    }

    return approveHrd;
  }

  bool canBatal(IzinList item) {
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
