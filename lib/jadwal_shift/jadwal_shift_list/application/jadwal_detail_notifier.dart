import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import 'jadwal_shift_detail.dart';
import 'jadwal_shift_list_notifier.dart';

part 'jadwal_detail_notifier.g.dart';

final jadwalShiftDetailNamaProvider = StateProvider<List<String>>((ref) {
  return [];
});

@riverpod
class JadwalDetailController extends _$JadwalDetailController {
  @override
  FutureOr<List<JadwalShiftDetail>> build() {
    return [];
  }

  Future<void> loadDetail({required int idShift}) async {
    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return ref.read(jadwalShiftListRepositoryProvider).getJadwalShiftDetail(
            idShift: idShift,
            username: username,
            pass: pass,
          );
    });
  }

  Future<void> modify(
    Function() checkList,
    Function(JadwalShiftDetail item) addToParam, {
    required JadwalShiftDetail item,
    required int idx,
  }) async {
    state = state.copyWithPrevious(state);

    final List<JadwalShiftDetail> list = [
      ...state.requireValue.mapIndexed((index, e) => index == idx ? item : e)
    ];

    state = AsyncValue.data(list);

    addToParam(item);
    checkList();
  }
}
