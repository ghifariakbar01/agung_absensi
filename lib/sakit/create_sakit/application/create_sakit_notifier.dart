import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../infrastructures/create_sakit_remote_service.dart';
import '../infrastructures/create_sakit_repository.dart';

part 'create_sakit_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateSakitRemoteService createSakitRemoteService(
    CreateSakitRemoteServiceRef ref) {
  return CreateSakitRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
CreateSakitRepository createSakitRepository(CreateSakitRepositoryRef ref) {
  return CreateSakitRepository(
    ref.watch(createSakitRemoteServiceProvider),
  );
}

@riverpod
class CreateSakitNotifier extends _$CreateSakitNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> submitSakit({
    required DateTime tglStart,
    required DateTime tglEnd,
    required String keterangan,
    required String surat,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;
    final idUser = user.idUser!;

    final _tglStart = DateFormat('yyyy-MM-dd').format(tglStart);
    final _tglEnd = DateFormat('yyyy-MM-dd').format(tglEnd);

    try {
      await ref.read(createSakitRepositoryProvider).submitSakit(
            idUser: idUser,
            username: username,
            pass: pass,
            ket: keterangan,
            surat: surat,
            tglEnd: _tglEnd,
            tglStart: _tglStart,
          );

      state = const AsyncValue.data('Sukses Input');
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<void> updateSakit({
    required int idSakit,
    required DateTime tglStart,
    required DateTime tglEnd,
    required String keterangan,
    required String surat,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;
    final idUser = user.idUser!;

    final _tglStart = DateFormat('yyyy-MM-dd').format(tglStart);
    final _tglEnd = DateFormat('yyyy-MM-dd').format(tglEnd);

    try {
      await ref.read(createSakitRepositoryProvider).updateSakit(
            idSakit: idSakit,
            idUser: idUser,
            username: username,
            pass: pass,
            ket: keterangan,
            surat: surat,
            tglEnd: _tglEnd,
            tglStart: _tglStart,
          );

      state = const AsyncValue.data('Sukses Update');
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<void> deleteSakit({
    required int idSakit,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    try {
      await ref.read(createSakitRepositoryProvider).deleteSakit(
            idSakit: idSakit,
            username: username,
            pass: pass,
          );

      state = const AsyncValue.data('Sukses Delete');
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }
}
