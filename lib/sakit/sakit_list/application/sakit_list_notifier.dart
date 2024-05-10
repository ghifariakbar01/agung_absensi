import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../infrastructure/sakit_list_remote_service.dart';
import '../infrastructure/sakit_list_repository.dart';
import 'sakit_list.dart';

part 'sakit_list_notifier.g.dart';

@Riverpod(keepAlive: true)
SakitListRemoteService sakitListRemoteService(SakitListRemoteServiceRef ref) {
  return SakitListRemoteService(
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
SakitListRepository sakitListRepository(SakitListRepositoryRef ref) {
  return SakitListRepository(
    ref.watch(sakitListRemoteServiceProvider),
  );
}

@riverpod
class SakitListController extends _$SakitListController {
  @override
  FutureOr<List<SakitList>> build() {
    return _determineAndGetSakitListOn(page: 0);
  }

  Future<void> load({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    state = const AsyncLoading<List<SakitList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetSakitListOn(
        page: page,
        dateRange: dateRange,
        searchUser: searchUser,
      );

      final List<SakitList> list = [
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
      return _determineAndGetSakitListOn(
          page: 0, searchUser: searchUser, dateRange: dateRange);
    });
  }

  Future<List<SakitList>> _determineAndGetSakitListOn({
    required int page,
    String? searchUser,
    DateTimeRange? dateRange,
  }) async {
    final hrd = ref.read(userNotifierProvider).user.fin;

    final staff = ref.read(userNotifierProvider).user.staf!;
    final staffStr = staff.replaceAll('"', '').substring(0, staff.length - 1);

    if (isHrdOrSpv(hrd)) {
      return ref.read(sakitListRepositoryProvider).getSakitList(
            page: page,
            searchUser: searchUser ?? '',
            dateRange: dateRange ??
                DateTimeRange(
                    start: DateTime.now().subtract(Duration(days: 30)),
                    end: DateTime.now()),
          );
    } else {
      return ref.read(sakitListRepositoryProvider).getSakitListLimitedAccess(
            page: page,
            staff: staffStr,
            searchUser: searchUser ?? '',
            dateRange: dateRange ??
                DateTimeRange(
                    start: DateTime.now().subtract(Duration(days: 30)),
                    end: DateTime.now()),
          );
    }
  }

  bool _isAct() {
    final server = ref.read(userNotifierProvider).user.ptServer;
    return server == 'gs_12';
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
      _isSpvEdit = spv!.contains('5010,');
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
      _isHrdOrSpv = access!.contains('2,');
    } else {
      _isHrdOrSpv = access!.contains('5101,');
    }

    return _isHrdOrSpv;
  }
}
