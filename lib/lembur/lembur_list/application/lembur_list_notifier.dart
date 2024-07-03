import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../helper.dart';
import '../../../shared/providers.dart';

import '../infrastructures/lembur_list_remote_service.dart';
import '../infrastructures/lembur_list_repository.dart';
import 'lembur_list.dart';

part 'lembur_list_notifier.g.dart';

@Riverpod(keepAlive: true)
LemburListRemoteService lemburListRemoteService(
    LemburListRemoteServiceRef ref) {
  return LemburListRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
LemburListRepository lemburListRepository(LemburListRepositoryRef ref) {
  return LemburListRepository(
    ref.watch(lemburListRemoteServiceProvider),
  );
}

@riverpod
class LemburListController extends _$LemburListController {
  @override
  FutureOr<List<LemburList>> build() {
    return _determineAndGetLemburListOn(
      page: 0,
    );
  }

  Future<void> load({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    state = const AsyncLoading<List<LemburList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetLemburListOn(
        page: page,
        dateRange: dateRange,
        searchUser: searchUser,
      );

      final List<LemburList> list = [
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
      return _determineAndGetLemburListOn(
        page: 0,
        dateRange: dateRange,
        searchUser: searchUser,
      );
    });
  }

  Future<List<LemburList>> _determineAndGetLemburListOn({
    required int page,
    String? searchUser,
    DateTimeRange? dateRange,
  }) async {
    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    final List<LemburList> _list =
        await ref.read(lemburListRepositoryProvider).getLemburList(
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
