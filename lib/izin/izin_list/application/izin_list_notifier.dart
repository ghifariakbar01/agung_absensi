import 'package:face_net_authentication/wa_head_helper/application/wa_head_helper_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../../../wa_head_helper/application/wa_head.dart';
import '../infrastructure/izin_list_remote_service.dart';
import '../infrastructure/izin_list_repository.dart';
import 'izin_list.dart';
import 'jenis_izin.dart';

part 'izin_list_notifier.g.dart';

@Riverpod(keepAlive: true)
IzinListRemoteService izinListRemoteService(IzinListRemoteServiceRef ref) {
  return IzinListRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
IzinListRepository izinListRepository(IzinListRepositoryRef ref) {
  return IzinListRepository(
    ref.watch(izinListRemoteServiceProvider),
  );
}

@riverpod
class IzinListController extends _$IzinListController {
  @override
  FutureOr<List<IzinList>> build() {
    return _determineAndGetIzinListOn(page: 0);
  }

  Future<void> load({required int page}) async {
    state = const AsyncLoading<List<IzinList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetIzinListOn(page: page);

      final List<IzinList> list = [
        ...state.requireValue.toList(),
        ...res,
      ];

      return list;
    });
  }

  Future<List<JenisIzin>> getJenisIzin() async {
    return ref.read(izinListRepositoryProvider).getJenisIzin();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _determineAndGetIzinListOn(page: 0);
    });
  }

  Future<List<IzinList>> _determineAndGetIzinListOn({required int page}) async {
    final hrd = ref.read(userNotifierProvider).user.fin;
    final spv = ref.read(userNotifierProvider).user.spv;
    final fullAkses = ref.read(userNotifierProvider).user.fullAkses;

    if (fullAkses || isHrdOrSpv(hrd) || isHrdOrSpv(spv)) {
      return ref.read(izinListRepositoryProvider).getIzinList(page: page);
    } else {
      final idUser = ref.read(userNotifierProvider).user.idUser;

      final List<WaHead> waHeads = await ref
          .read(waHeadHelperNotifierProvider.notifier)
          .getWaHeads(idUser: idUser!);

      return ref.read(izinListRepositoryProvider).getIzinListLimitedAccess(
          page: page, idUserHead: waHeads.first.idUserHead!);
    }
  }

  bool _isAct() {
    final server = ref.read(userNotifierProvider).user.ptServer;
    return server == 'gs_12';
  }

  bool isSpvEdit() {
    final spv = ref.read(userNotifierProvider).user.spv;
    final fullAkses = ref.read(userNotifierProvider).user.fullAkses;

    if (spv == null) {
      return false;
    }

    if (fullAkses == false) {
      return false;
    }

    if (_isAct()) {
      return spv.contains(',10,');
    } else {
      return spv.contains(',5012,');
    }
  }

  bool isHrdOrSpv(String? access) {
    final fullAkses = ref.read(userNotifierProvider).user.fullAkses;

    if (access == null) {
      return false;
    }

    if (fullAkses == false) {
      return false;
    }

    if (_isAct()) {
      return access.contains(',18,');
    } else {
      return access.contains(',5103,');
    }
  }
}
