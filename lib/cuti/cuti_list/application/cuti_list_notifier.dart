import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';

import '../infrastructure/cuti_list_remote_service.dart';
import '../infrastructure/cuti_list_repository.dart';
import 'cuti_list.dart';

part 'cuti_list_notifier.g.dart';

@Riverpod(keepAlive: true)
CutiListRemoteService cutiListRemoteService(CutiListRemoteServiceRef ref) {
  return CutiListRemoteService(
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CutiListRepository cutiListRepository(CutiListRepositoryRef ref) {
  return CutiListRepository(
    ref.watch(cutiListRemoteServiceProvider),
  );
}

@riverpod
class CutiListController extends _$CutiListController {
  @override
  FutureOr<List<CutiList>> build() {
    return _determineAndGetCutiListOn(page: 0);
  }

  Future<void> load({required int page}) async {
    state = const AsyncLoading<List<CutiList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetCutiListOn(page: page);

      final List<CutiList> list = [
        ...state.requireValue.toList(),
        ...res,
      ];

      return list;
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _determineAndGetCutiListOn(page: 0);
    });
  }

  Future<List<CutiList>> _determineAndGetCutiListOn({required int page}) async {
    final hrd = ref.read(userNotifierProvider).user.fin;

    final staff = ref.read(userNotifierProvider).user.staf!;
    final staffStr = staff.replaceAll('"', '').substring(0, staff.length - 1);

    if (isHrdOrSpv(hrd)) {
      return ref.read(cutiListRepositoryProvider).getCutiList(
            page: page,
          );
    } else {
      return ref.read(cutiListRepositoryProvider).getCutiListLimitedAccess(
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
      return spv.contains('10,');
    } else {
      return spv.contains('5011,');
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
      return access.contains('1,');
    } else {
      return access.contains('5102,');
    }
  }
}
