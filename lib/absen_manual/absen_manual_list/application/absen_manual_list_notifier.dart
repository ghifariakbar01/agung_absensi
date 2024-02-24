import 'package:face_net_authentication/wa_head_helper/application/wa_head_helper_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../../../wa_head_helper/application/wa_head.dart';
import '../infrastructure/absen_manual_list_remote_service.dart';
import '../infrastructure/absen_manual_list_repository.dart';
import 'absen_manual_list.dart';

part 'absen_manual_list_notifier.g.dart';

@Riverpod(keepAlive: true)
AbsenManualListRemoteService absenManualListRemoteService(
    AbsenManualListRemoteServiceRef ref) {
  return AbsenManualListRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
AbsenManualListRepository absenManualListRepository(
    AbsenManualListRepositoryRef ref) {
  return AbsenManualListRepository(
    ref.watch(absenManualListRemoteServiceProvider),
  );
}

@riverpod
class AbsenManualListController extends _$AbsenManualListController {
  @override
  FutureOr<List<AbsenManualList>> build() {
    return _determineAndGetIzinListOn(page: 0);
  }

  Future<void> load({required int page}) async {
    state = const AsyncLoading<List<AbsenManualList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetIzinListOn(page: page);

      final List<AbsenManualList> list = [
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

  Future<List<AbsenManualList>> _determineAndGetIzinListOn(
      {required int page}) async {
    if (isHrdOrSpv()) {
      return ref
          .read(absenManualListRepositoryProvider)
          .getAbsenManualList(page: page);
    } else {
      final idUser = ref.read(userNotifierProvider).user.idUser;

      final List<WaHead> waHeads = await ref
          .read(waHeadHelperNotifierProvider.notifier)
          .getWaHeads(idUser: idUser!);

      return ref
          .read(absenManualListRepositoryProvider)
          .getAbsenManualListLimitedAccess(
              page: page, idUserHead: waHeads.first.idUserHead!);
    }
  }

  bool isHrdOrSpv() {
    return ref.read(userNotifierProvider).user.isSpvOrHrd ?? false;
  }
}
