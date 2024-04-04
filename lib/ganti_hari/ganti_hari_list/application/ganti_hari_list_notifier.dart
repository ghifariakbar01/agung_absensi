import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';

import '../infrastructure/ganti_hari_list_remote_service.dart';
import '../infrastructure/ganti_hari_list_repository.dart';
import 'ganti_hari_list.dart';

part 'ganti_hari_list_notifier.g.dart';

@Riverpod(keepAlive: true)
GantiHariListRemoteService gantiHariListRemoteService(
    GantiHariListRemoteServiceRef ref) {
  return GantiHariListRemoteService(
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
GantiHariListRepository gantiHariListRepository(
    GantiHariListRepositoryRef ref) {
  return GantiHariListRepository(
    ref.watch(gantiHariListRemoteServiceProvider),
  );
}

@riverpod
class GantiHariListController extends _$GantiHariListController {
  @override
  FutureOr<List<GantiHariList>> build() {
    return _determineAndGetGantiHariListOn(page: 0);
  }

  Future<void> load({required int page}) async {
    state = const AsyncLoading<List<GantiHariList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetGantiHariListOn(page: page);

      final List<GantiHariList> list = [
        ...state.requireValue.toList(),
        ...res,
      ];

      return list;
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _determineAndGetGantiHariListOn(page: 0);
    });
  }

  Future<List<GantiHariList>> _determineAndGetGantiHariListOn(
      {required int page}) async {
    final hrd = ref.read(userNotifierProvider).user.fin;

    final staff = ref.read(userNotifierProvider).user.staf!;
    final staffStr = staff.replaceAll('"', '').substring(0, staff.length - 1);

    if (isHrdOrSpv(hrd)) {
      return ref.read(gantiHariListRepositoryProvider).getGantiHariList(
            page: page,
          );
    } else {
      return ref
          .read(gantiHariListRepositoryProvider)
          .getGantiHariListLimitedAccess(
            page: page,
            staff: staffStr,
          );
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

    if (fullAkses! == false) {
      return false;
    }

    if (_isAct()) {
      return spv.contains('38,');
    } else {
      return spv.contains('5015,');
    }
  }

  bool isHrdOrSpv(String? access) {
    final fullAkses = ref.read(userNotifierProvider).user.fullAkses;

    if (access == null) {
      return false;
    }

    if (fullAkses! == false) {
      return false;
    }

    if (_isAct()) {
      return access.contains('17,');
    } else {
      return access.contains('5106,');
    }
  }
}
