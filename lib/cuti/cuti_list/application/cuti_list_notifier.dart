// ignore_for_file: sdk_version_since

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../helper.dart';
import '../../../shared/providers.dart';

import '../infrastructures/cuti_list_remote_service.dart';
import '../infrastructures/cuti_list_repository.dart';
import 'cuti_list.dart';

part 'cuti_list_notifier.g.dart';

@Riverpod(keepAlive: true)
CutiListRemoteService cutiListRemoteService(CutiListRemoteServiceRef ref) {
  return CutiListRemoteService(
    ref.watch(dioProviderCuti),
  );
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
    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    final List<CutiList> _list =
        await ref.read(cutiListRepositoryProvider).getCutiList(
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
