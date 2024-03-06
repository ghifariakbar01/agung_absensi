import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../send_wa/application/phone_num.dart';
import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';

import '../../absen_manual_list/application/absen_manual_list.dart';

import '../../absen_manual_list/application/absen_manual_list_notifier.dart';
import '../infrastructure/absen_manual_approve_remote_service.dart.dart';
import '../infrastructure/absen_manual_approve_repository.dart';

part 'absen_manual_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
AbsenManualApproveRemoteService absenManualApproveRemoteService(
    AbsenManualApproveRemoteServiceRef ref) {
  return AbsenManualApproveRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
AbsenManualApproveRepository absenManualApproveRepository(
    AbsenManualApproveRepositoryRef ref) {
  return AbsenManualApproveRepository(
    ref.watch(absenManualApproveRemoteServiceProvider),
  );
}

@riverpod
class AbsenManualApproveController extends _$AbsenManualApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> _sendWa(
      {required AbsenManualList item, required String messageContent}) async {
    final PhoneNum registeredWa = PhoneNum(
      noTelp1: item.noTelp1,
      noTelp2: item.noTelp2,
    );

    if (registeredWa.noTelp1!.isNotEmpty) {
      await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
          phone: int.parse(registeredWa.noTelp1!),
          idUser: item.idUser,
          idDept: item.idDept,
          notifTitle: 'Notifikasi HRMS',
          notifContent: '$messageContent');
    } else if (registeredWa.noTelp2!.isNotEmpty) {
      await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
          phone: int.parse(registeredWa.noTelp2!),
          idUser: item.idUser,
          idDept: item.idDept,
          notifTitle: 'Notifikasi HRMS',
          notifContent: '$messageContent');
    } else {
      throw AssertionError(
          'User yang dituju tidak memiliki nomor telfon. Silahkan hubungi HR ');
    }
  }

  Future<void> approveSpv({
    required String nama,
    required AbsenManualList item,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(absenManualApproveRepositoryProvider)
          .approveSpv(nama: nama, idAbsenMnl: item.idAbsenmnl);
      final String messageContent =
          'Izin Absen Manual Anda Sudah Diapprove Oleh Atasan $nama';
      await _sendWa(item: item, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Absen Manual');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveSpv({
    required String nama,
    required AbsenManualList item,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(absenManualApproveRepositoryProvider)
          .unApproveSpv(nama: nama, idAbsenMnl: item.idAbsenmnl);

      state = AsyncData<void>('Sukses Unapprove Form Absen Manual');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> approveHrd({
    required String namaHrd,
    required String note,
    required AbsenManualList item,
  }) async {
    state = const AsyncLoading();

    try {
      await ref.read(absenManualApproveRepositoryProvider).approveHrd(
          namaHrd: namaHrd, note: note, idAbsenMnl: item.idAbsenmnl);

      final String messageContent =
          'Izin Absen Manual Anda Sudah Diapprove Oleh HRD $namaHrd';
      await _sendWa(item: item, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Absen Manual');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveHrd({
    required String namaHrd,
    required String note,
    required int idAbsenMnl,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(absenManualApproveRepositoryProvider)
          .unApproveHrd(nama: namaHrd, note: note, idAbsenMnl: idAbsenMnl);

      state = AsyncData<void>('Sukses Melakukan Unapprove Form Absen Manual');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> batal({
    required String nama,
    required AbsenManualList item,
  }) async {
    state = const AsyncLoading();

    try {
      await ref.read(absenManualApproveRepositoryProvider).batal(
            nama: nama,
            idAbsenMnl: item.idAbsenmnl,
          );
      final String messageContent = 'Izin Anda Telah Di Batalkan Oleh : $nama';

      await _sendWa(item: item, messageContent: messageContent);
      state = AsyncData<void>('Sukses Membatalkan Form Absen Manual');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  int _calcDiffSaturdaySunday(DateTime startDate, DateTime endDate) {
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

  bool canSpvApprove(AbsenManualList item) {
    bool spvApprove = true;

    if (item.hrdSta == true) {
      spvApprove = false;
    }

    final spv = ref.read(userNotifierProvider).user.spv;
    if (ref.read(absenManualListControllerProvider.notifier).isHrdOrSpv(spv) ==
        false) {
      spvApprove = false;
    }

    final staff = ref.read(userNotifierProvider).user.staf;
    if (staff!.contains(item.idUser.toString()) == false) {
      spvApprove = false;
    }

    final jumlahHari =
        _calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now());

    if (DateTime.now().difference(DateTime.parse(item.cDate!)).inDays -
            jumlahHari >=
        3) {
      spvApprove = false;
    }

    if (ref.read(userNotifierProvider).user.idUser != item.idUser) {
      spvApprove = false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      spvApprove = true;
    }

    return spvApprove;
  }

  bool canHrdApprove(AbsenManualList item) {
    bool hrdApprove = true;

    if (item.spvSta == false) {
      hrdApprove = false;
    }

    final hrd = ref.read(userNotifierProvider).user.fin;

    if (ref.read(absenManualListControllerProvider.notifier).isHrdOrSpv(hrd) ==
        false) {
      hrdApprove = false;
    }

    final jumlahHari =
        _calcDiffSaturdaySunday(DateTime.parse(item.spvTgl!), DateTime.now());

    if (DateTime.now().difference(DateTime.parse(item.cDate!)).inDays -
            jumlahHari >=
        1) {
      hrdApprove = false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      hrdApprove = true;
    }

    return hrdApprove;
  }

  bool canBatal(AbsenManualList item) {
    if (item.btlSta == true && item.hrdSta == true) {
      return false;
    }

    return true;
  }
}
