import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/providers.dart';

import '../infrastructures/jadwal_shift_list_remote_service.dart';
import '../infrastructures/jadwal_shift_list_repository.dart';
import 'jadwal_shift_list.dart';

part 'jadwal_shift_list_notifier.g.dart';

@Riverpod(keepAlive: true)
JadwalShiftListRemoteService jadwalShiftListRemoteService(
    JadwalShiftListRemoteServiceRef ref) {
  return JadwalShiftListRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
JadwalShiftListRepository jadwalShiftListRepository(
    JadwalShiftListRepositoryRef ref) {
  return JadwalShiftListRepository(
    ref.watch(jadwalShiftListRemoteServiceProvider),
  );
}

@riverpod
class JadwalShiftListController extends _$JadwalShiftListController {
  @override
  FutureOr<List<JadwalShiftList>> build() {
    return _determineAndGetJadwalShiftListOn(page: 0);
  }

  Future<void> load({
    required int page,
    required String searchUser,
  }) async {
    state = const AsyncLoading<List<JadwalShiftList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await _determineAndGetJadwalShiftListOn(
        page: page,
        searchUser: searchUser,
      );

      final List<JadwalShiftList> list = [
        ...state.requireValue.toList(),
        ...res,
      ];

      return list;
    });
  }

  Future<void> refresh({
    required String searchUser,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _determineAndGetJadwalShiftListOn(page: 0, searchUser: searchUser);
    });
  }

  Future<List<JadwalShiftList>> _determineAndGetJadwalShiftListOn({
    required int page,
    String? searchUser,
  }) async {
    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    final List<JadwalShiftList> _list =
        await ref.read(jadwalShiftListRepositoryProvider).getJadwalShiftList(
              username: username,
              pass: pass,
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
