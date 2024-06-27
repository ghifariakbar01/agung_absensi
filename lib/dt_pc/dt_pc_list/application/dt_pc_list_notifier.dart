// ignore_for_file: sdk_version_since

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../helper.dart';
import '../../../shared/providers.dart';
import '../infrastructures/dt_pc_list_remote_service.dart';
import '../infrastructures/dt_pc_list_repository.dart';
import 'dt_pc_list.dart';

part 'dt_pc_list_notifier.g.dart';

@Riverpod(keepAlive: true)
DtPcListRemoteService dtPcListRemoteService(DtPcListRemoteServiceRef ref) {
  return DtPcListRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
DtPcListRepository dtPcListRepository(DtPcListRepositoryRef ref) {
  return DtPcListRepository(
    ref.watch(dtPcListRemoteServiceProvider),
  );
}

@riverpod
class DtPcListController extends _$DtPcListController {
  @override
  FutureOr<List<DtPcList>> build() {
    return _determineAndGetDTPCListOn(page: 0);
  }

  Future<void> load({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    state = const AsyncLoading<List<DtPcList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetDTPCListOn(
        page: page,
        dateRange: dateRange,
        searchUser: searchUser,
      );

      final List<DtPcList> list = [
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
      return _determineAndGetDTPCListOn(
        page: 0,
        dateRange: dateRange,
        searchUser: searchUser,
      );
    });
  }

  Future<List<DtPcList>> _determineAndGetDTPCListOn({
    required int page,
    String? searchUser,
    DateTimeRange? dateRange,
  }) async {
    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    final List<DtPcList> _list =
        await ref.read(dtPcListRepositoryProvider).getDtPcList(
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
