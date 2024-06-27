// ignore_for_file: sdk_version_since

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../helper.dart';
import '../../../shared/providers.dart';
import '../infrastructures/izin_list_remote_service.dart';
import '../infrastructures/izin_list_repository.dart';
import 'izin_list.dart';
import 'jenis_izin.dart';

part 'izin_list_notifier.g.dart';

@Riverpod(keepAlive: true)
IzinListRemoteService izinListRemoteService(IzinListRemoteServiceRef ref) {
  return IzinListRemoteService(
    ref.watch(dioProviderCuti),
  );
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
    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    final List<IzinList> _list =
        await ref.read(izinListRepositoryProvider).getIzinList(
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
