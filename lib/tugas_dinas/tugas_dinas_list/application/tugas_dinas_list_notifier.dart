import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
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
    final hrd = ref.read(userNotifierProvider).user.fin;
    final gm = ref.read(userNotifierProvider).user.gm;
    final coo = ref.read(userNotifierProvider).user.coo;
    final idDept = ref.read(userNotifierProvider).user.idDept;

    final staff = ref.read(userNotifierProvider).user.staf!;
    final staffStr = staff.replaceAll('"', '').substring(0, staff.length - 1);

    if (idDept == 2 || isHrdOrSpv(hrd) || isHrdOrSpv(gm) || isHrdOrSpv(coo)) {
      return ref
          .read(tugasDinasListRepositoryProvider)
          .getTugasDinasList(page: page);
    } else {
      return ref
          .read(tugasDinasListRepositoryProvider)
          .getTugasDinasListLimitedAccess(page: page, staff: staffStr);
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
      return spv.contains('10,');
    } else {
      return spv.contains('5017,');
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
      return access.contains('4,');
    } else {
      return access.contains('5108,');
    }
  }
}
