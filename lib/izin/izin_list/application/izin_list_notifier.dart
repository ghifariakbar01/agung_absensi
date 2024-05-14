import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../infrastructure/izin_list_remote_service.dart';
import '../infrastructure/izin_list_repository.dart';
import 'izin_list.dart';
import 'jenis_izin.dart';

part 'izin_list_notifier.g.dart';

@Riverpod(keepAlive: true)
IzinListRemoteService izinListRemoteService(IzinListRemoteServiceRef ref) {
  return IzinListRemoteService(
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
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

  Future<void> load({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    state = const AsyncLoading<List<IzinList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetIzinListOn(
        page: page,
        dateRange: dateRange,
        searchUser: searchUser,
      );

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

  Future<void> refresh({
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _determineAndGetIzinListOn(
        page: 0,
        dateRange: dateRange,
        searchUser: searchUser,
      );
    });
  }

  Future<List<IzinList>> _determineAndGetIzinListOn({
    required int page,
    String? searchUser,
    DateTimeRange? dateRange,
  }) async {
    final hrd = ref.read(userNotifierProvider).user.fin;

    final staff = ref.read(userNotifierProvider).user.staf!;
    final staffStr = staff.replaceAll('"', '').substring(0, staff.length - 1);

    if (isHrdOrSpv(hrd)) {
      return ref.read(izinListRepositoryProvider).getIzinList(
            page: page,
            searchUser: searchUser ?? '',
            dateRange: dateRange ??
                DateTimeRange(
                    start: DateTime.now().subtract(Duration(days: 30)),
                    end: DateTime.now().add(Duration(days: 1))),
          );
    } else {
      return ref.read(izinListRepositoryProvider).getIzinListLimitedAccess(
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
      return spv.contains('5012,');
    }
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
      _isHrdOrSpv = access!.contains('18,');
    } else {
      _isHrdOrSpv = access!.contains('5103,');
    }

    return _isHrdOrSpv;
  }
}
