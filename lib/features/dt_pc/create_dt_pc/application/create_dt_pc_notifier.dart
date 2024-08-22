import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../infrastructures/exceptions.dart';
import '../../../../shared/providers.dart';

import '../infrastructures/create_dt_pc_remote_service.dart';
import '../infrastructures/create_dt_pc_repository.dart';

part 'create_dt_pc_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateDtPcRemoteService createDtPcRemoteService(
    CreateDtPcRemoteServiceRef ref) {
  return CreateDtPcRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
CreateDtPcRepository createDtPcRepository(CreateDtPcRepositoryRef ref) {
  return CreateDtPcRepository(
    ref.watch(createDtPcRemoteServiceProvider),
  );
}

@riverpod
class CreateDtPcNotifier extends _$CreateDtPcNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> submitDtPc({
    required int idUser,
    required String ket,
    required String dtTgl,
    required String jam,
    required String kategori,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;
    final idUser = user.idUser!;

    try {
      await ref.read(createDtPcRepositoryProvider).submitDtPc(
            idUser: idUser,
            username: username,
            pass: pass,
            ket: ket,
            dtTgl: dtTgl,
            jam: jam,
            kategori: kategori,
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

  Future<void> updateDtPc({
    required int id,
    required int idUser,
    required String ket,
    required String dtTgl,
    required String jam,
    required String kategori,
    required String noteSpv,
    required String noteHrd,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;
    final idUser = user.idUser!;

    try {
      await ref.read(createDtPcRepositoryProvider).updateDtPc(
            id: id,
            idUser: idUser,
            username: username,
            pass: pass,
            ket: ket,
            dtTgl: dtTgl,
            jam: jam,
            kategori: kategori,
            noteSpv: noteSpv,
            noteHrd: noteHrd,
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

  Future<void> deleteDtPc({
    required int idDt,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    try {
      await ref.read(createDtPcRepositoryProvider).deleteDtPc(
            idDt: idDt,
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
