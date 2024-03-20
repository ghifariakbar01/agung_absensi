import 'dart:developer';

import 'package:face_net_authentication/ganti_hari/ganti_hari_list/application/ganti_hari_list_notifier.dart';
import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../send_wa/application/phone_num.dart';
import '../../../shared/providers.dart';

import '../../ganti_hari_list/application/ganti_hari_list.dart';
import '../infrastructure/ganti_hari_approve_remote_service.dart.dart';
import '../infrastructure/ganti_hari_approve_repository.dart';

part 'ganti_hari_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
GantiHariApproveRemoteService gantiHariApproveRemoteService(
    GantiHariApproveRemoteServiceRef ref) {
  return GantiHariApproveRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
GantiHariApproveRepository gantiHariApproveRepository(
    GantiHariApproveRepositoryRef ref) {
  return GantiHariApproveRepository(
    ref.watch(gantiHariApproveRemoteServiceProvider),
  );
}

@riverpod
class GantiHariApproveController extends _$GantiHariApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> _sendWa({
    required String messageContent,
    required GantiHariList itemGantiHari,
  }) async {
    final PhoneNum registeredWa = await ref
        .read(sendWaNotifierProvider.notifier)
        .getPhoneById(idUser: itemGantiHari.idUser!);

    if (registeredWa.noTelp1!.isNotEmpty) {
      await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
          phone: int.parse(registeredWa.noTelp1!),
          idUser: itemGantiHari.idUser!,
          // idDept: itemGantiHari.idDept!,
          idDept: 1,
          notifTitle: 'Notifikasi HRMS',
          notifContent: '$messageContent');
    } else if (registeredWa.noTelp2!.isNotEmpty) {
      await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
          phone: int.parse(registeredWa.noTelp2!),
          idUser: itemGantiHari.idUser!,
          // idDept: itemGantiHari.idDept!,
          idDept: 1,
          notifTitle: 'Notifikasi HRMS',
          notifContent: '$messageContent');
    } else {
      throw AssertionError(
          'User yang dituju tidak memiliki nomor telfon. Silahkan hubungi HR untuk mengubah data ');
    }
  }

  Future<void> approveSpv({
    required String nama,
    required String note,
    required GantiHariList itemGantiHari,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(gantiHariApproveRepositoryProvider)
          .approveSpv(nama: nama, idDayOff: itemGantiHari.idDayOff!);

      final String messageContent =
          ' (Testing Apps) Izin Ganti Hari Anda Sudah Diapprove Oleh Atasan $nama ';
      await _sendWa(
          itemGantiHari: itemGantiHari, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Ganti Hari');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unapproveSpv({
    required String nama,
    required GantiHariList itemGantiHari,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(gantiHariApproveRepositoryProvider)
          .unapproveSpv(nama: nama, idDayOff: itemGantiHari.idDayOff!);

      state = AsyncData<void>('Sukses Melakukan Unapprove Form Ganti Hari');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> approveHrd({
    required String nama,
    required String note,
    required GantiHariList itemGantiHari,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(gantiHariApproveRepositoryProvider).approveHrd(
            nama: nama,
            note: note,
            itemGantiHari: itemGantiHari,
          );

      final String messageContent =
          'Izin Sakit Anda Sudah Diapprove Oleh HRD $nama';
      await _sendWa(
          itemGantiHari: itemGantiHari, messageContent: messageContent);

      return Future.value('Sukses Melakukan Approve Form Ganti Hari');
    });
  }

  Future<void> unapproveHrd({
    required String nama,
    required GantiHariList itemGantiHari,
  }) async {
    state = const AsyncLoading();

    try {
      await ref.read(gantiHariApproveRepositoryProvider).unapproveHrd(
            nama: nama,
            itemGantiHari: itemGantiHari,
          );

      state = AsyncData<void>('Sukses Melakukan Unapprove Form Ganti Hari');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> batal({
    required String nama,
    required GantiHariList itemGantiHari,
  }) async {
    state = const AsyncLoading();

    try {
      debugger();

      await ref.read(gantiHariApproveRepositoryProvider).batal(
            nama: nama,
            itemGantiHari: itemGantiHari,
          );

      final String messageContent =
          ' (Testing Apps) Izin Cuti Anda Telah Di Batalkan Oleh : $nama ';
      await _sendWa(
          itemGantiHari: itemGantiHari, messageContent: messageContent);

      debugger();

      state = AsyncData<void>('Sukses Membatalkan Form Ganti Hari');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<bool> canSpvApprove(GantiHariList item) async {
    bool approveSpv = false;

    final user = ref.read(userNotifierProvider).user;

    final staf = user.staf;
    if (staf == null) {
      approveSpv = false;
    }

    if (staf != null) {
      if (staf.contains('${item.idUser},')) {
        approveSpv = true;
      }
    }

    if (user.fullAkses == true) {
      approveSpv = true;
    }

    return approveSpv;
  }

  Future<bool> canHrdApprove(GantiHariList item) async {
    bool approveHrd = false;

    final user = ref.read(userNotifierProvider).user;
    if (ref
            .read(gantiHariListControllerProvider.notifier)
            .isHrdOrSpv(user.fin) ==
        false) {
      approveHrd = false;
    }

    if (user.fullAkses == true) {
      approveHrd = true;
    }

    return approveHrd;
  }

  bool canBatal(GantiHariList item) => item.btlSta == false;
}
