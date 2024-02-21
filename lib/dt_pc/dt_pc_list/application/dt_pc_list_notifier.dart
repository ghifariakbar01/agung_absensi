import 'package:face_net_authentication/wa_head_helper/application/wa_head_helper_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../../../wa_head_helper/application/wa_head.dart';
import '../infrastructure/dt_pc_list_remote_service.dart';
import '../infrastructure/dt_pc_list_repository.dart';
import 'dt_pc_list.dart';

part 'dt_pc_list_notifier.g.dart';

@Riverpod(keepAlive: true)
DtPcListRemoteService dtPcListRemoteService(DtPcListRemoteServiceRef ref) {
  return DtPcListRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
DtPcListRepository dtPcListRepository(DtPcListRepositoryRef ref) {
  return DtPcListRepository(
    ref.watch(dtPcListRemoteServiceProvider),
  );
}

@riverpod
class DtPcListController extends _$DtPcListController {
  @override
  FutureOr<List<DtPcList>> build() {
    return _determineAndGetIzinListOn(page: 0);
  }

  Future<void> load({required int page}) async {
    state = const AsyncLoading<List<DtPcList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetIzinListOn(page: page);

      final List<DtPcList> list = [
        ...state.requireValue.toList(),
        ...res,
      ];

      return list;
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _determineAndGetIzinListOn(page: 0);
    });
  }

  Future<List<DtPcList>> _determineAndGetIzinListOn({required int page}) async {
    if (isHrdOrSpv()) {
      return ref.read(dtPcListRepositoryProvider).getDtPcList(page: page);
    } else {
      final idUser = ref.read(userNotifierProvider).user.idUser;

      final List<WaHead> waHeads = await ref
          .read(waHeadHelperNotifierProvider.notifier)
          .getWaHeads(idUser: idUser!);

      return ref.read(dtPcListRepositoryProvider).getDtPcListLimitedAccess(
          page: page, idUserHead: waHeads.first.idUserHead!);
    }
  }

  bool isHrdOrSpv() {
    return ref.read(userNotifierProvider).user.isSpvOrHrd ?? false;
  }
}
