import 'package:face_net_authentication/wa_head_helper/application/wa_head_helper_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../../../wa_head_helper/application/wa_head.dart';
import '../infrastructure/sakit_list_remote_service.dart';
import '../infrastructure/sakit_list_repository.dart';
import 'sakit_list.dart';

part 'sakit_list_notifier.g.dart';

@Riverpod(keepAlive: true)
SakitListRemoteService sakitListRemoteService(SakitListRemoteServiceRef ref) {
  return SakitListRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
SakitListRepository sakitListRepository(SakitListRepositoryRef ref) {
  return SakitListRepository(
    ref.watch(sakitListRemoteServiceProvider),
  );
}

@riverpod
class SakitListController extends _$SakitListController {
  @override
  FutureOr<List<SakitList>> build() {
    return _determineAndGetSakitListOn(page: 0);
  }

  Future<void> load({required int page}) async {
    state = const AsyncLoading<List<SakitList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetSakitListOn(page: page);

      final List<SakitList> list = [
        ...state.requireValue.toList(),
        ...res,
      ];

      return list;
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _determineAndGetSakitListOn(page: 0);
    });
  }

  Future<List<SakitList>> _determineAndGetSakitListOn(
      {required int page}) async {
    if (isHrdOrSpv()) {
      return ref.read(sakitListRepositoryProvider).getSakitList(page: page);
    } else {
      final idUser = ref.read(userNotifierProvider).user.idUser;

      final List<WaHead> waHeads = await ref
          .read(waHeadHelperNotifierProvider.notifier)
          .getWaHeads(idUser: idUser!);

      return ref.read(sakitListRepositoryProvider).getSakitListLimitedAccess(
          page: page, idUserHead: waHeads.first.idUserHead!);
    }
  }

  bool isHrdOrSpv() {
    return ref.read(userNotifierProvider).user.isSpvOrHrd ?? false;
  }
}
