import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
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
    return _determineAndGetAbsenManualListOn(page: 0);
  }

  Future<void> load({required int page}) async {
    state = const AsyncLoading<List<AbsenManualList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetAbsenManualListOn(page: page);

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
      return _determineAndGetAbsenManualListOn(page: 0);
    });
  }

  Future<List<AbsenManualList>> _determineAndGetAbsenManualListOn(
      {required int page}) async {
    final hrd = ref.read(userNotifierProvider).user.fin;

    final staff = ref.read(userNotifierProvider).user.staf!;
    final staffStr = staff.replaceAll('"', '').substring(0, staff.length - 1);

    debugger();

    log('isHrdOrSpv(hrd) ${isHrdOrSpv(hrd)}');

    if (isHrdOrSpv(hrd)) {
      return ref.read(absenManualListRepositoryProvider).getAbsenManualList(
            page: page,
          );
    } else {
      return ref
          .read(absenManualListRepositoryProvider)
          .getAbsenManualListLimitedAccess(page: page, staff: staffStr);
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
      return spv.contains(',10,');
    } else {
      return spv.contains(',5014,');
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
      return access.contains('16,');
    } else {
      return access.contains('5105,');
    }
  }
}
