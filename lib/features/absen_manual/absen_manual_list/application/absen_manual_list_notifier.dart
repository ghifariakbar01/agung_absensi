import 'package:face_net_authentication/utils/logging.dart';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../helper.dart';
import '../../../../shared/providers.dart';
import '../infrastructures/absen_manual_list_remote_service.dart';
import '../infrastructures/absen_manual_list_repository.dart';
import 'absen_manual_list.dart';

part 'absen_manual_list_notifier.g.dart';

@Riverpod(keepAlive: true)
AbsenManualListRemoteService absenManualListRemoteService(
    AbsenManualListRemoteServiceRef ref) {
  return AbsenManualListRemoteService(
    ref.watch(dioProviderCuti),
  );
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
    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    Log.info('username : $username');
    Log.info('pass : $pass');

    final List<AbsenManualList> _list =
        await ref.read(absenManualListRepositoryProvider).getAbsenManualList(
              username: username,
              pass: pass,
              dateRange: dateRange ?? CalendarHelper.initialDateRange(),
            );

    if (searchUser == null) {
      return _list;
    } else {
      return _list.where((element) {
        if (element.fullname == null) {
          return element.cUser!.toLowerCase().contains(searchUser);
        } else {
          return element.fullname!.toLowerCase().contains(searchUser);
        }
      }).toList();
    }
  }
}
