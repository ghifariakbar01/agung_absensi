import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  sendWaSpv() {
    //

    //
  }

  sendWaHrd() {
    //

    //
  }

  Future<void> approveSpv(
      {required int idSakit,
      required String nama,
      required String note}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => ref
        .read(sakitApproveRepositoryProvider)
        .approveSpv(idSakit: idSakit, nama: nama, note: note));
  }

  Future<void> unapproveSpv({
    required String nama,
    required SakitList itemSakit,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
        () => ref.read(sakitApproveRepositoryProvider).unapproveSpv(
              itemSakit: itemSakit,
              nama: nama,
            ));
  }

  Future<void> approveHrdTanpaSurat({
    required String nama,
    required String note,
    required SakitList itemSakit,
    required CreateSakit createSakit,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => ref
        .read(sakitApproveRepositoryProvider)
        .approveHrdTanpaSurat(
            nama: nama,
            note: note,
            itemSakit: itemSakit,
            createSakit: createSakit));
  }

  Future<void> approveHrdDenganSurat({
    required String nama,
    required String note,
    required SakitList itemSakit,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
        () => ref.read(sakitApproveRepositoryProvider).approveHrdDenganSurat(
              nama: nama,
              note: note,
              itemSakit: itemSakit,
            ));
  }

  Future<void> unApproveHrdDenganSurat({
    required String nama,
    required SakitList itemSakit,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
        () => ref.read(sakitApproveRepositoryProvider).unApproveHrdDenganSurat(
              itemSakit: itemSakit,
              nama: nama,
            ));
  }

  Future<void> unApproveHrdTanpaSurat({
    required String nama,
    required SakitList itemSakit,
    required CreateSakit createSakit,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => ref
        .read(sakitApproveRepositoryProvider)
        .unApproveHrdTanpaSurat(
            nama: nama, itemSakit: itemSakit, createSakit: createSakit));
  }

  Future<void> batal({
    required String nama,
    required SakitList itemSakit,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
        () => ref.read(sakitApproveRepositoryProvider).batal(
              itemSakit: itemSakit,
              nama: nama,
            ));
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
