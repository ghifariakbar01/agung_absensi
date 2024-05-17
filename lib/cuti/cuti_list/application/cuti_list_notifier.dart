import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';

import '../infrastructures/cuti_list_remote_service.dart';
import '../infrastructures/cuti_list_repository.dart';
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
    return _determineAndGetCutiListOn(
      page: 0,
    );
  }

  Future<void> load({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    state = const AsyncLoading<List<CutiList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetCutiListOn(
        page: page,
        dateRange: dateRange,
        searchUser: searchUser,
      );

      final List<CutiList> list = [
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
      return _determineAndGetCutiListOn(
        page: 0,
        dateRange: dateRange,
        searchUser: searchUser,
      );
    });
  }

  Future<List<CutiList>> _determineAndGetCutiListOn({
    required int page,
    String? searchUser,
    DateTimeRange? dateRange,
  }) async {
    final hrd = ref.read(userNotifierProvider).user.fin;

    final staff = ref.read(userNotifierProvider).user.staf!;
    final staffStr = staff.replaceAll('"', '').substring(0, staff.length - 1);

    if (isHrdOrSpv(hrd)) {
      return ref.read(cutiListRepositoryProvider).getCutiList(
            page: page,
            searchUser: searchUser ?? '',
            dateRange: dateRange ??
                DateTimeRange(
                    start: DateTime.now().subtract(Duration(days: 30)),
                    end: DateTime.now().add(Duration(days: 1))),
          );
    } else {
      return ref.read(cutiListRepositoryProvider).getCutiListLimitedAccess(
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
      _isSpvEdit = spv!.contains('5011,');
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
      _isHrdOrSpv = access!.contains('1,');
    } else {
      _isHrdOrSpv = access!.contains('5102,');
    }

    return _isHrdOrSpv;
  }
}
