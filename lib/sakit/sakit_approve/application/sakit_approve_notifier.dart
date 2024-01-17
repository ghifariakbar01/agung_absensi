import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
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

  sendWaSpv() {}

  sendWaHrd() {}

  Future<void> approveSpv(
      {required int idSakit,
      required String nama,
      required String note}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => ref
        .read(sakitApproveRepositoryProvider)
        .approveSpv(idSakit: idSakit, nama: nama, note: note));
  }

  approveHrd(SakitList item) {
    if (item.hrdSta == false) {
      //
    } else {
      //
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

    if (ref.read(createSakitNotifierProvider.notifier).calcDiffSaturdaySunday(
            DateTime.parse(item.cDate!), DateTime.now()) >=
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

    if (ref.read(createSakitNotifierProvider.notifier).calcDiffSaturdaySunday(
            DateTime.parse(item.cDate!), DateTime.now()) >=
        1) {
      return false;
    }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      return true;
    }

    return false;
  }
}
