import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../helper.dart';
import '../../../shared/providers.dart';

import '../infrastructures/ganti_hari_list_remote_service.dart';
import '../infrastructures/ganti_hari_list_repository.dart';
import 'ganti_hari_list.dart';

part 'ganti_hari_list_notifier.g.dart';

@Riverpod(keepAlive: true)
GantiHariListRemoteService gantiHariListRemoteService(
    GantiHariListRemoteServiceRef ref) {
  return GantiHariListRemoteService(
    ref.watch(dioProviderCuti),
  );
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
    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    final List<GantiHariList> _list = await ref
        .read(gantiHariListRepositoryProvider)
        .getGantiHariList(
            username: username,
            pass: pass,
            dateRange: dateRange ?? CalendarHelper.initialDateRange());

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
