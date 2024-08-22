import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../infrastructures/exceptions.dart';
import '../../../../shared/providers.dart';
import '../../jadwal_shift_list/application/jadwal_shift_detail.dart';
import '../infrastructures/create_jadwal_shift_remote_service.dart';
import '../infrastructures/create_jadwal_shift_repository.dart';

part 'create_jadwal_shift_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateJadwalShiftRemoteService createJadwalShiftRemoteService(
    CreateJadwalShiftRemoteServiceRef ref) {
  return CreateJadwalShiftRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
CreateJadwalShiftRepository createJadwalShiftRepository(
    CreateJadwalShiftRepositoryRef ref) {
  return CreateJadwalShiftRepository(
    ref.watch(createJadwalShiftRemoteServiceProvider),
  );
}

@riverpod
class CreateJadwalShift extends _$CreateJadwalShift {
  @override
  FutureOr<void> build() async {}

  Future<void> submitJadwalShift({
    required DateTime dateTime,
    String? server = Constants.isDev ? 'testing' : 'live',
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;
    final idUser = user.idUser!;

    try {
      await ref.read(createJadwalShiftRepositoryProvider).submitJadwalShift(
            idUser: idUser,
            username: username,
            pass: pass,
            dateTime: dateTime,
            server: Constants.isDev ? 'testing' : 'live',
          );

      state = const AsyncValue.data('Sukses Input');
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<void> updateJadwalShift({
    required List<JadwalShiftDetailParam> listParam,
    String? server = Constants.isDev ? 'testing' : 'live',
    required Future<void> Function(String errMessage) onError,
  }) async {
    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    final list =
        listParam.where((e) => e != JadwalShiftDetailParam.initial()).toList();

    state = const AsyncLoading();

    try {
      for (int i = 0; i < list.length; i++) {
        final item = list[i];

        await ref.read(createJadwalShiftRepositoryProvider).updateJadwalShift(
              idShiftDtl: item.idShift,
              jadwal: item.jadwal,
              username: username,
              pass: pass,
              server: Constants.isDev ? 'testing' : 'live',
            );
      }

      state = const AsyncValue.data('Sukses Update');
    } catch (e) {
      state = const AsyncValue.data('');
      String _msg = e.toString();

      if (e is RestApiExceptionWithMessage) {
        _msg = e.errorCode.toString() + ' ' + e.message!;
      }

      await onError('Error $_msg');
    }
  }

  Future<void> deleteJadwalShift({
    required int idShift,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    try {
      await ref.read(createJadwalShiftRepositoryProvider).deleteJadwalShift(
            idShift: idShift,
            username: username,
            pass: pass,
          );

      state = const AsyncValue.data('Sukses Delete');
    } catch (e) {
      state = const AsyncValue.data('');
      String _msg = e.toString();

      if (e is RestApiExceptionWithMessage) {
        _msg = e.errorCode.toString() + ' ' + e.message!;
      }

      await onError('Error $_msg');
    }
  }
}
