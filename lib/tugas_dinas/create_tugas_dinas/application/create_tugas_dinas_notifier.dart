// ignore_for_file: sdk_version_since

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/constants.dart';
import '../../../infrastructures/exceptions.dart';
import '../../../shared/providers.dart';

import '../infrastructures/create_tugas_dinas_remote_service.dart';
import '../infrastructures/create_tugas_dinas_repository.dart';
import 'jenis_tugas_dinas.dart';
import 'user_list.dart';

part 'create_tugas_dinas_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateTugasDinasRemoteService createTugasDinasRemoteService(
    CreateTugasDinasRemoteServiceRef ref) {
  return CreateTugasDinasRemoteService(
    ref.watch(dioProviderCuti),
    ref.watch(dioProvider),
    ref.watch(dioRequestProvider),
  );
}

@Riverpod(keepAlive: true)
CreateTugasDinasRepository createTugasDinasRepository(
    CreateTugasDinasRepositoryRef ref) {
  return CreateTugasDinasRepository(
    ref.watch(createTugasDinasRemoteServiceProvider),
  );
}

@riverpod
class JenisTugasDinasNotifier extends _$JenisTugasDinasNotifier {
  @override
  FutureOr<List<JenisTugasDinas>> build() async {
    return ref.read(createTugasDinasRepositoryProvider).getJenisTugasDinas();
  }
}

@riverpod
class PemberiTugasDinasNotifier extends _$PemberiTugasDinasNotifier {
  @override
  FutureOr<List<UserList>> build() async {
    return [];
  }

  Future<void> getPemberiTugasListNamed(String nama) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => ref
        .read(createTugasDinasRepositoryProvider)
        .getPemberiTugasListNamed(nama));
  }
}

@riverpod
class CreateTugasDinasNotifier extends _$CreateTugasDinasNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> submitTugasDinas({
    required int idPemberi,
    required String ket,
    required String tglAwal,
    required String tglAkhir,
    required String jamAwal,
    required String jamAkhir,
    required String kategori,
    required String perusahaan,
    required String lokasi,
    required bool jenis,
    required Future<void> Function(String errMessage) onError,
  }) async {
    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;
    final idUser = user.idUser!;

    state = const AsyncLoading();

    try {
      await ref.read(createTugasDinasRepositoryProvider).submitTugasDinas(
            idUser: idUser,
            username: username,
            pass: pass,
            idPemberi: idPemberi,
            ket: ket,
            tglAwal: tglAwal,
            tglAkhir: tglAkhir,
            jamAwal: jamAwal,
            jamAkhir: jamAkhir,
            kategori: kategori,
            perusahaan: perusahaan,
            lokasi: lokasi,
            jenis: jenis,
            server: Constants.isDev ? 'testing' : 'live',
          );

      state = const AsyncValue.data('Sukses Input');
    } catch (e) {
      state = const AsyncValue.data('');
      String _msg = e.toString();

      if (e is RestApiExceptionWithMessage) {
        _msg = e.errorCode.toString() + ' ' + e.message!;
      }

      await onError('Error $_msg');
    }
  }

  Future<void> updateTugasDinas({
    required int idDinas,
    required int idPemberi,
    required String ket,
    required String tglAwal,
    required String tglAkhir,
    required String jamAwal,
    required String jamAkhir,
    required String kategori,
    required String perusahaan,
    required String lokasi,
    required bool jenis,
    required Future<void> Function(String errMessage) onError,
  }) async {
    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;
    final idUser = user.idUser!;

    state = const AsyncLoading();

    try {
      await ref.read(createTugasDinasRepositoryProvider).updateTugasDinas(
            idDinas: idDinas,
            idUser: idUser,
            username: username,
            pass: pass,
            idPemberi: idPemberi,
            ket: ket,
            tglAwal: tglAwal,
            tglAkhir: tglAkhir,
            jamAwal: jamAwal,
            jamAkhir: jamAkhir,
            kategori: kategori,
            perusahaan: perusahaan,
            lokasi: lokasi,
            jenis: jenis,
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

  Future<void> deleteTugasDinas({
    required int idDinas,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    try {
      await ref.read(createTugasDinasRepositoryProvider).deleteTugasDinas(
            idDinas: idDinas,
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
