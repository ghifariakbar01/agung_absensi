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

  bool canSpvApprove(TugasDinasList item) {
    bool approveSpv = true;

    if (item.gmSta == true) {
      approveSpv = false;
    }

    final staff = ref.read(userNotifierProvider).user.staf!;
    if (staff.contains(item.idUser.toString()) == false) {
      approveSpv = false;
    }

    if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
      approveSpv = true;
    }

    if (item.kategori != null) {
      final jumlahHari = _calcDiffSaturdaySunday(
          DateTime.parse(item.tglStart!), DateTime.now());

      if (item.kategori == 'LK' && item.jenis == false) {
        if (DateTime.now().difference(DateTime.parse(item.tglStart!)).inDays +
                jumlahHari >
            -2) {
          approveSpv = false;
        }
      } else {
        if (item.jenis == false &&
            (DateTime.now().difference(DateTime.parse(item.cDate!)).inDays -
                    jumlahHari >
                1)) {
          approveSpv = false;
        }
      }
    }

    final spv = ref.read(userNotifierProvider).user.spv;

    if (ref.read(tugasDinasListControllerProvider.notifier).isHrdOrSpv(spv) ==
        false) {
      approveSpv = false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      approveSpv = true;
    }

    return approveSpv;
  }

  bool canGmApprove(TugasDinasList item) {
    bool approveGm = true;

    if (item.spvSta == false) {
      approveGm = false;
    }

    if (item.hrdSta == true) {
      approveGm = false;
    }

    final gm = ref.read(userNotifierProvider).user.gm;

    if (ref.read(tugasDinasListControllerProvider.notifier).isHrdOrSpv(gm) ==
        false) {
      approveGm = false;
    }

    final dept = ref.read(userNotifierProvider).user.deptList;

    if (dept!.contains(item.idDept.toString()) == false) {
      approveGm = false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      approveGm = true;
    }

    if (item.kategori != 'LK' && item.kategori != 'KJ') {
      approveGm = false;
    }

    return approveGm;
  }

  bool canHrdApprove(TugasDinasList item) {
    bool approveHrd = true;

    if (item.cooSta == true) {
      approveHrd = false;
    }

    if (item.gmSta == false) {
      approveHrd = false;
    }

    final hrd = ref.read(userNotifierProvider).user.fin;
    if (ref.read(tugasDinasListControllerProvider.notifier).isHrdOrSpv(hrd) ==
        false) {
      approveHrd = false;
    }

    final jumlahHari =
        DateTime.now().difference(DateTime.parse(item.spvTgl!)).inDays;
    final jumlahHariLibur =
        _calcDiffSaturdaySunday(DateTime.parse(item.gmTgl!), DateTime.now());

    if (jumlahHari - jumlahHariLibur >= 2) {
      approveHrd = false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      approveHrd = true;
    }

    return approveHrd;
  }

  bool canCooApprove(TugasDinasList item) {
    bool approveCoo = true;

    if (item.hrdSta == false) {
      approveCoo = false;
    }

    final coo = ref.read(userNotifierProvider).user.coo;
    if (ref.read(tugasDinasListControllerProvider.notifier).isHrdOrSpv(coo) ==
        false) {
      approveCoo = false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      approveCoo = true;
    }

    if (item.kategori != 'LK') {
      approveCoo = false;
    }

    final ptServer = ref.read(userNotifierProvider).user.ptServer;
    if (ptServer == 'gs_18') {
      approveCoo = false;
    }

    return approveCoo;
  }

  bool canBatal(TugasDinasList item) {
    if (item.btlSta == true || item.cooSta == true) {
      return false;
    }

    return true;
  }
}
