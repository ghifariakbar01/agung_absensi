import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';

import '../infrastructures/ganti_hari_list_remote_service.dart';
import '../infrastructures/ganti_hari_list_repository.dart';
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

  Future<void> load({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    state = const AsyncLoading<List<GantiHariList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetGantiHariListOn(
        page: page,
        dateRange: dateRange,
        searchUser: searchUser,
      );

      final List<GantiHariList> list = [
        ...state.requireValue.toList(),
        ...res,
      ];

      return list;
    });
  }

  Future<void> refresh({
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _determineAndGetGantiHariListOn(
          page: 0, searchUser: searchUser, dateRange: dateRange);
    });
  }

  Future<List<GantiHariList>> _determineAndGetGantiHariListOn({
    required int page,
    String? searchUser,
    DateTimeRange? dateRange,
  }) async {
    final hrd = ref.read(userNotifierProvider).user.fin;

    final staff = ref.read(userNotifierProvider).user.staf!;
    final staffStr = staff.replaceAll('"', '').substring(0, staff.length - 1);

    if (isHrdOrSpv(hrd)) {
      return ref.read(gantiHariListRepositoryProvider).getGantiHariList(
            page: page,
            searchUser: searchUser ?? '',
            dateRange: dateRange ??
                DateTimeRange(
                    start: DateTime.now().subtract(Duration(days: 30)),
                    end: DateTime.now().add(Duration(days: 1))),
          );
    } else {
      return ref
          .read(gantiHariListRepositoryProvider)
          .getGantiHariListLimitedAccess(
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
      _isSpvEdit = spv!.contains('38,');
    } else {
      _isSpvEdit = spv!.contains('5015,');
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
      _isHrdOrSpv = access!.contains('17,');
    } else {
      _isHrdOrSpv = access!.contains('5106,');
    }

    return _isHrdOrSpv;
  }
}
