import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../infrastructures/exceptions.dart';

import '../../../../shared/providers.dart';
import '../infrastructures/create_ganti_hari_remote_service.dart';
import '../infrastructures/create_ganti_hari_repository.dart';
import 'absen_ganti_hari.dart';

part 'create_ganti_hari_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateGantiHariRemoteService createGantiHariRemoteService(
    CreateGantiHariRemoteServiceRef ref) {
  return CreateGantiHariRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
CreateGantiHariRepository createGantiHariRepository(
    CreateGantiHariRepositoryRef ref) {
  return CreateGantiHariRepository(
    ref.watch(createGantiHariRemoteServiceProvider),
  );
}

@riverpod
class AbsenGantiHariNotifier extends _$AbsenGantiHariNotifier {
  @override
  FutureOr<List<AbsenGantiHari>> build() async {
    return ref.read(createGantiHariRepositoryProvider).getAbsenGantiHari();
  }
}

@riverpod
class CreateGantiHari extends _$CreateGantiHari {
  @override
  FutureOr<void> build() async {}

  Future<void> submitGantiHari({
    required int idAbsen,
    required String ket,
    required String tglOff,
    required String tglGanti,
    String? server = Constants.isDev ? 'testing' : 'live',
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;
    final idUser = user.idUser!;

    try {
      await ref.read(createGantiHariRepositoryProvider).submitGantiHari(
            idUser: idUser,
            idAbsen: idAbsen,
            username: username,
            pass: pass,
            ket: ket,
            tglOff: tglOff,
            tglGanti: tglGanti,
            server: Constants.isDev ? 'testing' : 'live',
          );

      state = const AsyncValue.data('Sukses Input');
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<void> updateGantiHari({
    required int idDayOff,
    required int idAbsen,
    required String ket,
    required String tglOff,
    required String tglGanti,
    String? server = Constants.isDev ? 'testing' : 'live',
    required Future<void> Function(String errMessage) onError,
  }) async {
    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;
    final idUser = user.idUser!;

    state = const AsyncLoading();

    try {
      await ref.read(createGantiHariRepositoryProvider).updateGantiHari(
            idDayOff: idDayOff,
            idUser: idUser,
            idAbsen: idAbsen,
            username: username,
            pass: pass,
            ket: ket,
            tglOff: tglOff,
            tglGanti: tglGanti,
            server: Constants.isDev ? 'testing' : 'live',
          );

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

  Future<void> deleteGantiHari({
    required int idDayOff,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    try {
      await ref.read(createGantiHariRepositoryProvider).deleteGantiHari(
            idDayOff: idDayOff,
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
