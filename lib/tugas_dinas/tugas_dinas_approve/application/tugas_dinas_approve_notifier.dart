import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../send_wa/application/phone_num.dart';
import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';
import '../../tugas_dinas_list/application/tugas_dinas_list.dart';
import '../../tugas_dinas_list/application/tugas_dinas_list_notifier.dart';
import '../infrastructure/tugas_dinas_approve_remote_service.dart.dart';
import '../infrastructure/tugas_dinas_approve_repository.dart';

part 'tugas_dinas_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
TugasDinasApproveRemoteService tugasDinasApproveRemoteService(
    TugasDinasApproveRemoteServiceRef ref) {
  return TugasDinasApproveRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
TugasDinasApproveRepository tugasDinasApproveRepository(
    TugasDinasApproveRepositoryRef ref) {
  return TugasDinasApproveRepository(
    ref.watch(tugasDinasApproveRemoteServiceProvider),
  );
}

@riverpod
class TugasDinasApproveController extends _$TugasDinasApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> _sendWa(
      {required TugasDinasList item, required String messageContent}) async {
    final PhoneNum registeredWa = PhoneNum(
      noTelp1: item.noTelp1,
      noTelp2: item.noTelp2,
    );

    if (registeredWa.noTelp1 != null) {
      if (registeredWa.noTelp1!.isNotEmpty)
        await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
            phone: int.parse(registeredWa.noTelp1!),
            idUser: item.idUser,
            idDept: item.idDept,
            notifTitle: 'Notifikasi HRMS',
            notifContent: '$messageContent');
    } else if (registeredWa.noTelp2 != null) {
      if (registeredWa.noTelp2!.isNotEmpty)
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

  Future<void> processSpv({
    required String nama,
    required TugasDinasList item,
  }) async {
    return item.spvSta == false
        ? approveSpv(nama: nama, item: item)
        : unApproveSpv(nama: nama, item: item);
  }

  Future<void> processGm({
    required String namaGm,
    required String ptServer,
    required TugasDinasList item,
  }) async {
    return item.gmSta == false
        ? approveGm(namaGm: namaGm, ptServer: ptServer, item: item)
        : unApproveGm(namaGm: namaGm, ptServer: ptServer, item: item);
  }

  Future<void> processHrd({
    required String namaHrd,
    required TugasDinasList item,
  }) async {
    return item.hrdSta == false
        ? approveHrd(namaHrd: namaHrd, item: item)
        : unApproveHrd(namaHrd: namaHrd, item: item);
  }

  Future<void> processCOO({
    required String namaCoo,
    required TugasDinasList item,
  }) async {
    return item.cooSta == false
        ? approveCOO(namaCoo: namaCoo, item: item)
        : unApproveCOO(namaCoo: namaCoo, item: item);
  }

  Future<void> approveSpv({
    required String nama,
    required TugasDinasList item,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(tugasDinasApproveRepositoryProvider)
          .approveSpv(nama: nama, idDinas: item.idDinas);
      // final String messageContent =
      //     'Izin Dinas Anda Sudah Di Approve Oleh Atasan $nama';
      // await _sendWa(item: item, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Tugas Dinas');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveSpv({
    required String nama,
    required TugasDinasList item,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(tugasDinasApproveRepositoryProvider)
          .unApproveSpv(nama: nama, idDinas: item.idDinas);

      state = AsyncData<void>('Sukses Unapprove Form Tugas Dinas');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> approveGm({
    required String namaGm,
    required String ptServer,
    required TugasDinasList item,
  }) async {
    state = const AsyncLoading();

    try {
      if (item.kategori == 'LK' && ptServer != 'gs_18') {
        await ref
            .read(tugasDinasApproveRepositoryProvider)
            .approveCOO(idDinas: item.idDinas, namaCoo: namaGm);
      }

      await ref
          .read(tugasDinasApproveRepositoryProvider)
          .approveGm(namaGm: namaGm, idDinas: item.idDinas);
      final String messageContent =
          'Izin Dinas Anda Sudah Di Approve Oleh GM $namaGm';
      await _sendWa(item: item, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Tugas Dinas');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveGm({
    required String namaGm,
    required String ptServer,
    required TugasDinasList item,
  }) async {
    state = const AsyncLoading();

    try {
      if (item.kategori == 'LK' && ptServer != 'gs_12') {
        await ref
            .read(tugasDinasApproveRepositoryProvider)
            .unApproveCOO(idDinas: item.idDinas, namaCoo: namaGm);
      }

      await ref
          .read(tugasDinasApproveRepositoryProvider)
          .unapproveGm(namaGm: namaGm, idDinas: item.idDinas);

      state = AsyncData<void>('Sukses Melakukan Unapprove Form Tugas Dinas');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> approveHrd({
    required String namaHrd,
    required TugasDinasList item,
  }) async {
    state = const AsyncLoading();

    try {
      if (item.kategori == 'LK') {
        await ref
            .read(tugasDinasApproveRepositoryProvider)
            .approveHrdLK(namaHrd: namaHrd, idDinas: item.idDinas);

        final String messageContent =
            'Izin Dinas Anda Sudah Diapprove Oleh HRD $namaHrd';
        await _sendWa(item: item, messageContent: messageContent);
      } else {
        await ref
            .read(tugasDinasApproveRepositoryProvider)
            .approveHrd(namaHrd: namaHrd, idDinas: item.idDinas);

        final String messageContent =
            'Izin Dinas Anda Sudah Diapprove Oleh HRD $namaHrd';
        await _sendWa(item: item, messageContent: messageContent);
      }

      state = AsyncData<void>('Sukses Melakukan Approve Form Tugas Dinas');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveHrd({
    required String namaHrd,
    required TugasDinasList item,
  }) async {
    state = const AsyncLoading();

    try {
      if (item.kategori == 'LK') {
        await ref
            .read(tugasDinasApproveRepositoryProvider)
            .unapproveHrdLK(nama: namaHrd, idDinas: item.idDinas);
      } else {
        await ref
            .read(tugasDinasApproveRepositoryProvider)
            .unapproveHrd(namaHrd: namaHrd, idDinas: item.idDinas);
      }

      state = AsyncData<void>('Sukses Melakukan Unapprove Form Tugas Dinas');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> approveCOO({
    required String namaCoo,
    required TugasDinasList item,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(tugasDinasApproveRepositoryProvider)
          .approveCOO(namaCoo: namaCoo, idDinas: item.idDinas);
      final String messageContent =
          'Izin Dinas Anda Sudah Di Approve Oleh COO $namaCoo';
      await _sendWa(item: item, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Tugas Dinas');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveCOO({
    required String namaCoo,
    required TugasDinasList item,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(tugasDinasApproveRepositoryProvider)
          .unApproveCOO(namaCoo: namaCoo, idDinas: item.idDinas);

      state = AsyncData<void>('Sukses Unapprove Form Tugas Dinas');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> batal({
    required String nama,
    required TugasDinasList item,
  }) async {
    state = const AsyncLoading();

    try {
      await ref.read(tugasDinasApproveRepositoryProvider).batal(
            nama: nama,
            idDinas: item.idDinas,
          );
      final String messageContent = 'Izin Anda Telah Di Batalkan Oleh : $nama';

      await _sendWa(item: item, messageContent: messageContent);
      state = AsyncData<void>('Sukses Membatalkan Form Tugas Dinas');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  bool canSpvApprove(TugasDinasList item) {
    if (item.hrdSta == true) {
      return false;
    }

    if (ref.read(tugasDinasListControllerProvider.notifier).isHrdOrSpv() ==
        false) {
      return false;
    }

    if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
      return false;
    }

    // if (calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now()) >=
    //     3) {
    //   return false;
    // }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      return true;
    }

    return false;
  }

  bool canHrdApprove(TugasDinasList item) {
    if (item.spvSta == false) {
      return false;
    }

    if (item.hrdSta == true) {
      return false;
    }

    if (ref.read(tugasDinasListControllerProvider.notifier).isHrdOrSpv() ==
        false) {
      return false;
    }

    if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
      return false;
    }

    // if (calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now()) >=
    //     1) {
    //   return false;
    // }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      return true;
    }

    return false;
  }
}
