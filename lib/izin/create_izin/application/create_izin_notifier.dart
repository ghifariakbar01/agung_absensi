import 'package:face_net_authentication/infrastructures/exceptions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';

import '../infrastructures/create_izin_remote_service.dart';
import '../infrastructures/create_izin_repository.dart';

part 'create_izin_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateIzinRemoteService createIzinRemoteService(
    CreateIzinRemoteServiceRef ref) {
  return CreateIzinRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
CreateIzinRepository createIzinRepository(CreateIzinRepositoryRef ref) {
  return CreateIzinRepository(
    ref.watch(createIzinRemoteServiceProvider),
  );
}

@riverpod
class CreateIzinNotifier extends _$CreateIzinNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> submitIzin({
    required int idUser,
    required int idMstIzin,
    required String ket,
    required String cUser,
    required String tglAwal,
    required String tglAkhir,
    required String keterangan,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    try {
      await ref.read(createIzinRepositoryProvider).submitIzin(
          username: username,
          pass: pass,
          idUser: idUser,
          idMstIzin: idMstIzin,
          ket: ket,
          cUser: cUser,
          tglEnd: tglAkhir,
          tglStart: tglAwal);

      state = const AsyncValue.data('Sukses Submit');
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<void> updateIzin({
    required int idIzin,
    required int idUser,
    required int idMstIzin,
    required String ket,
    required String tglAwal,
    required String tglAkhir,
    required String noteSpv,
    required String noteHrd,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    try {
      final user = ref.read(userNotifierProvider).user;
      final username = user.nama!;
      final pass = user.password!;

      await ref.read(createIzinRepositoryProvider).updateIzin(
          idIzin: idIzin,
          username: username,
          pass: pass,
          idUser: idUser,
          idMstIzin: idMstIzin,
          ket: ket,
          tglEnd: tglAkhir,
          tglStart: tglAwal,
          noteSpv: noteSpv,
          noteHrd: noteHrd);

      state = const AsyncValue.data('Sukses Update');
    } catch (e) {
      state = const AsyncValue.data('');
      if (e is RestApiExceptionWithMessage) await onError('Error ${e.message}');
    }
  }

  Future<void> deleteIzin({
    required int idIzin,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    try {
      await ref.read(createIzinRepositoryProvider).deleteIzin(
            idIzin: idIzin,
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
