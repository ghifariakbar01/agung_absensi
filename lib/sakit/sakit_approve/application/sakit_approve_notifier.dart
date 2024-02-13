import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti_notifier.dart';
import '../../../send_wa/application/phone_num.dart';
import '../../../shared/providers.dart';
import '../../create_sakit/application/create_sakit.dart';

import '../../create_sakit/application/create_sakit_notifier.dart';
import '../../sakit_list/application/sakit_list.dart';
import '../../sakit_list/application/sakit_list_notifier.dart';
import '../infrastructure/sakit_approve_remote_service.dart.dart';
import '../infrastructure/sakit_approve_repository.dart';

part 'sakit_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
SakitApproveRemoteService sakitApproveRemoteService(
    SakitApproveRemoteServiceRef ref) {
  return SakitApproveRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
SakitApproveRepository sakitApproveRepository(SakitApproveRepositoryRef ref) {
  return SakitApproveRepository(
    ref.watch(sakitApproveRemoteServiceProvider),
  );
}

@riverpod
class SakitApproveController extends _$SakitApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> _sendWa(
      {required SakitList itemSakit, required String messageContent}) async {
    // debugger();

    final PhoneNum registeredWa = await ref
        .read(sendWaNotifierProvider.notifier)
        .getPhoneById(idUser: itemSakit.idUser!);

    if (registeredWa.noTelp1!.isNotEmpty) {
      await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
          phone: int.parse(registeredWa.noTelp1!),
          idUser: itemSakit.idUser!,
          idDept: itemSakit.idDept!,
          notifTitle: 'Notifikasi HRMS',
          notifContent: '$messageContent');
    } else if (registeredWa.noTelp2!.isNotEmpty) {
      await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
          phone: int.parse(registeredWa.noTelp2!),
          idUser: itemSakit.idUser!,
          idDept: itemSakit.idDept!,
          notifTitle: 'Notifikasi HRMS',
          notifContent: '$messageContent');
    } else {
      throw AssertionError(
          'User yang dituju tidak memiliki nomor telfon. Silahkan hubungi HR ');
    }
  }

  Future<void> approveSpv(
      {required String nama,
      required String note,
      required SakitList itemSakit}) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(sakitApproveRepositoryProvider)
          .approveSpv(nama: nama, note: note, idSakit: itemSakit.idSakit!);
      final String messageContent =
          'Izin Sakit Anda Sudah Diapprove Oleh Atasan $nama';
      await _sendWa(itemSakit: itemSakit, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Sakit');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unapproveSpv({
    required String nama,
    required SakitList itemSakit,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(sakitApproveRepositoryProvider)
          .unapproveSpv(nama: nama, itemSakit: itemSakit);
      final String messageContent =
          'Izin Sakit Anda Sudah Diapprove Oleh Atasan $nama';
      await _sendWa(itemSakit: itemSakit, messageContent: messageContent);

      state = AsyncData<void>('Sukses Unapprove Form Sakit');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> approveHrdTanpaSurat({
    required String namaHrd,
    required String note,
    required SakitList itemSakit,
  }) async {
    state = const AsyncLoading();

    try {
      final CreateSakit createSakit = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(
              itemSakit.idUser!, itemSakit.tglStart!, itemSakit.tglEnd!);
      final MstKaryawanCuti mstCutiUser = await ref
          .read(mstKaryawanCutiNotifierProvider.notifier)
          .getSaldoMasterCutiById(itemSakit.idUser!);

      await ref.read(sakitApproveRepositoryProvider).approveHrdTanpaSurat(
          namaHrd: namaHrd,
          note: note,
          itemSakit: itemSakit,
          createSakit: createSakit,
          mstCutiUser: mstCutiUser);

      final String messageContent =
          'Izin Sakit Anda Sudah Diapprove Oleh HRD $namaHrd';

      await _sendWa(itemSakit: itemSakit, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Sakit');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> approveHrdDenganSurat({
    required String namaHrd,
    required String note,
    required SakitList itemSakit,
  }) async {
    state = const AsyncLoading();

    try {
      await ref.read(sakitApproveRepositoryProvider).approveHrdDenganSurat(
            nama: namaHrd,
            note: note,
            itemSakit: itemSakit,
          );

      final String messageContent =
          'Izin Sakit Anda Sudah Diapprove Oleh HRD $namaHrd';

      await _sendWa(itemSakit: itemSakit, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Sakit');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveHrdDenganSurat({
    required String nama,
    required SakitList itemSakit,
  }) async {
    state = const AsyncLoading();

    try {
      await ref.read(sakitApproveRepositoryProvider).unApproveHrdDenganSurat(
            nama: nama,
            itemSakit: itemSakit,
          );

      state = AsyncData<void>('Sukses Unapprove Form Sakit');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveHrdTanpaSurat({
    required String nama,
    required SakitList itemSakit,
  }) async {
    state = const AsyncLoading();

    try {
      final CreateSakit createSakit = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(
              itemSakit.idUser!, itemSakit.tglStart!, itemSakit.tglEnd!);
      final MstKaryawanCuti mstCutiUser = await ref
          .read(mstKaryawanCutiNotifierProvider.notifier)
          .getSaldoMasterCutiById(itemSakit.idUser!);

      await ref.read(sakitApproveRepositoryProvider).unApproveHrdTanpaSurat(
          nama: nama,
          itemSakit: itemSakit,
          createSakit: createSakit,
          mstCuti: mstCutiUser);

      state = AsyncData<void>('Sukses Unapprove Form Sakit');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> batal({
    required String nama,
    required SakitList itemSakit,
  }) async {
    state = const AsyncLoading();

    try {
      await ref.read(sakitApproveRepositoryProvider).batal(
            nama: nama,
            itemSakit: itemSakit,
          );
      final String messageContent =
          'Izin Sakit Anda Telah Di Batalkan Oleh : $nama';

      await _sendWa(itemSakit: itemSakit, messageContent: messageContent);
      state = AsyncData<void>('Sukses Membatalkan Form Sakit');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  bool canSpvApprove(SakitList item) {
    if (item.hrdSta == true) {
      return false;
    }

    if (ref.read(sakitListControllerProvider.notifier).isHrdOrSpv() == false) {
      return false;
    }

    if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
      return false;
    }

    if (calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now()) >=
        3) {
      return false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      return true;
    }

    return false;
  }

  bool canHrdApprove(SakitList item) {
    if (item.spvSta == false) {
      return false;
    }

    if (item.hrdSta == true) {
      return false;
    }

    if (ref.read(sakitListControllerProvider.notifier).isHrdOrSpv() == false) {
      return false;
    }

    if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
      return false;
    }

    if (calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now()) >=
        1) {
      return false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      return true;
    }

    return false;
  }
}
