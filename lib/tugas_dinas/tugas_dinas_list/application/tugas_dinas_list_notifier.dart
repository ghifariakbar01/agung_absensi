import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../infrastructures/tugas_dinas_list_remote_service.dart';
import '../infrastructures/tugas_dinas_list_repository.dart';
import 'mst_user_list.dart';
import 'tugas_dinas_list.dart';

part 'tugas_dinas_list_notifier.g.dart';

@Riverpod(keepAlive: true)
TugasDinasListRemoteService tugasDinasListRemoteService(
    TugasDinasListRemoteServiceRef ref) {
  return TugasDinasListRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
TugasDinasListRepository tugasDinasListRepository(
    TugasDinasListRepositoryRef ref) {
  return TugasDinasListRepository(
    ref.watch(tugasDinasListRemoteServiceProvider),
  );
}

@riverpod
class MstUserListNotifier extends _$MstUserListNotifier {
  @override
  FutureOr<List<MstUserList>> build() async {
    return ref.read(tugasDinasListRepositoryProvider).getMasterUserList();
  }
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
        page: 0,
        searchUser: searchUser,
        dateRange: dateRange,
      );
    });
  }

  Future<List<TugasDinasList>> _determineAndGetTugasDinasListOn({
    required int page,
    String? searchUser,
    DateTimeRange? dateRange,
  }) async {
    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    final List<TugasDinasList> _list =
        await ref.read(tugasDinasListRepositoryProvider).getTugasDinasList(
              username: username,
              pass: pass,
              dateRange: dateRange ??
                  DateTimeRange(
                    start: DateTime.now().subtract(Duration(days: 30)),
                    end: DateTime.now().add(Duration(days: 1)),
                  ),
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
