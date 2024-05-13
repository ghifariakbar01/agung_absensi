import 'package:flutter/material.dart';
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
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
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

  Future<void> load({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    state = const AsyncLoading<List<TugasDinasList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetTugasDinasListOn(
        page: page,
        dateRange: dateRange,
        searchUser: searchUser,
      );

      final List<TugasDinasList> list = [
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
      return _determineAndGetTugasDinasListOn(
          page: 0, searchUser: searchUser, dateRange: dateRange);
    });
  }

  Future<List<TugasDinasList>> _determineAndGetTugasDinasListOn({
    required int page,
    String? searchUser,
    DateTimeRange? dateRange,
  }) async {
    final hrd = ref.read(userNotifierProvider).user.fin;
    final gm = ref.read(userNotifierProvider).user.gm;
    final coo = ref.read(userNotifierProvider).user.coo;
    final idDept = ref.read(userNotifierProvider).user.idDept;

    final staff = ref.read(userNotifierProvider).user.staf!;
    final staffStr = staff.replaceAll('"', '').substring(0, staff.length - 1);

    if (idDept == 2 || isHrdOrSpv(hrd) || isHrdOrSpv(gm) || isHrdOrSpv(coo)) {
      return ref.read(tugasDinasListRepositoryProvider).getTugasDinasList(
            page: page,
            searchUser: searchUser ?? '',
            dateRange: dateRange ??
                DateTimeRange(
                    start: DateTime.now().subtract(Duration(days: 30)),
                    end: DateTime.now().add(Duration(days: 1))),
          );
    } else {
      return ref
          .read(tugasDinasListRepositoryProvider)
          .getTugasDinasListLimitedAccess(
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
      _isSpvEdit = spv!.contains('10,');
    } else {
      _isSpvEdit = spv!.contains('5017,');
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
      _isHrdOrSpv = access!.contains('4,');
    } else {
      _isHrdOrSpv = access!.contains('5108,');
    }

    return _isHrdOrSpv;
  }
}
