import 'package:face_net_authentication/wa_head_helper/application/wa_head_helper_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../../../wa_head_helper/application/wa_head.dart';
import '../infrastructure/tugas_dinas_list_remote_service.dart';
import '../infrastructure/tugas_dinas_list_repository.dart';
import 'tugas_dinas_list.dart';

part 'tugas_dinas_list_notifier.g.dart';

@Riverpod(keepAlive: true)
TugasDinasListRemoteService tugasDinasListRemoteService(
    TugasDinasListRemoteServiceRef ref) {
  return TugasDinasListRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
TugasDinasListRepository tugasDinasListRepository(
    TugasDinasListRepositoryRef ref) {
  return TugasDinasListRepository(
    ref.watch(tugasDinasListRemoteServiceProvider),
  );
}

@riverpod
class TugasDinasListController extends _$TugasDinasListController {
  @override
  FutureOr<List<TugasDinasList>> build() {
    return _determineAndGetTugasDinasListOn(page: 0);
  }

  Future<void> load({required int page}) async {
    state = const AsyncLoading<List<TugasDinasList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetTugasDinasListOn(page: page);

      final List<TugasDinasList> list = [
        ...state.requireValue.toList(),
        ...res,
      ];

      return list;
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _determineAndGetTugasDinasListOn(page: 0);
    });
  }

  Future<List<TugasDinasList>> _determineAndGetTugasDinasListOn(
      {required int page}) async {
    if (isHrdOrSpv()) {
      return ref
          .read(tugasDinasListRepositoryProvider)
          .getTugasDinasList(page: page);
    } else {
      final idUser = ref.read(userNotifierProvider).user.idUser;

      final List<WaHead> waHeads = await ref
          .read(waHeadHelperNotifierProvider.notifier)
          .getWaHeads(idUser: idUser!);

      return ref
          .read(tugasDinasListRepositoryProvider)
          .getTugasDinasListLimitedAccess(
              page: page, idUserHead: waHeads.first.idUserHead!);
    }
  }

  bool isHrdOrSpv() {
    return ref.read(userNotifierProvider).user.isSpvOrHrd ?? false;
  }
}
