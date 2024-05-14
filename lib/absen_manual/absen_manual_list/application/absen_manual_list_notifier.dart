import 'package:flutter/material.dart';
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
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
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

  Future<void> load({
    required int page,
    String? searchUser,
    DateTimeRange? dateRange,
  }) async {
    state = const AsyncLoading<List<AbsenManualList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetAbsenManualListOn(
          page: page, searchUser: searchUser, dateRange: dateRange);

      final List<AbsenManualList> list = [
        ...state.requireValue.toList(),
        ...res,
      ];

      return list;
    });
  }

  Future<void> search({
    String? searchUser,
    DateTimeRange? dateRange,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _determineAndGetAbsenManualListOn(
          page: 0, searchUser: searchUser, dateRange: dateRange);
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _determineAndGetAbsenManualListOn(page: 0);
    });
  }

  Future<List<AbsenManualList>> _determineAndGetAbsenManualListOn({
    required int page,
    String? searchUser,
    DateTimeRange? dateRange,
  }) async {
    final hrd = ref.read(userNotifierProvider).user.fin;

    final staff = ref.read(userNotifierProvider).user.staf!;
    final staffStr = staff.replaceAll('"', '').substring(0, staff.length - 1);

    if (isHrdOrSpv(hrd)) {
      return ref.read(absenManualListRepositoryProvider).getAbsenManualList(
            page: page,
            staff: staffStr,
            searchUser: searchUser ?? '',
            dateRange: dateRange ??
                DateTimeRange(
                    start: DateTime.now().subtract(Duration(days: 30)),
                    end: DateTime.now().add(Duration(days: 1))),
          );
    } else {
      return ref
          .read(absenManualListRepositoryProvider)
          .getAbsenManualListLimitedAccess(
            page: page,
            staff: staffStr,
            searchUser: searchUser ?? '',
            dateRange: dateRange ??
                DateTimeRange(
                    start: DateTime.now().subtract(Duration(days: 30)),
                    end: DateTime.now().add(Duration(days: 1))),
          );
    }
  }

  bool _isAct() {
    final server = ref.read(userNotifierProvider).user.ptServer;
    return server != 'gs_18';
  }

  bool isSpvEdit() {
    bool _isSpvEdit = true;

    final spv = ref.read(userNotifierProvider).user.spv;
    final fullAkses = ref.read(userNotifierProvider).user.fullAkses;

    if (spv == null) {
      _isSpvEdit = false;
    }

    if (fullAkses! == false) {
      _isSpvEdit = false;
    }

    if (_isAct()) {
      _isSpvEdit = spv!.contains(',10,');
    } else {
      _isSpvEdit = spv!.contains(',5014,');
    }

    return _isSpvEdit;
  }

  bool isHrdOrSpv(String? access) {
    bool _isHrdOrSpv = true;

    final fullAkses = ref.read(userNotifierProvider).user.fullAkses;

    if (access == null) {
      _isHrdOrSpv = false;
    }

    if (fullAkses! == false) {
      _isHrdOrSpv = false;
    }

    if (_isAct()) {
      _isHrdOrSpv = access!.contains('16,');
    } else {
      _isHrdOrSpv = access!.contains('5105,');
    }

    return _isHrdOrSpv;
  }


}
