import 'package:face_net_authentication/infrastructures/exceptions.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/providers.dart';
import '../infrastructures/create_cuti_remote_service.dart';
import '../infrastructures/create_cuti_repository.dart';
import 'alasan_cuti.dart';
import 'jenis_cuti.dart';

part 'create_cuti_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateCutiRemoteService createCutiRemoteService(
    CreateCutiRemoteServiceRef ref) {
  return CreateCutiRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
CreateCutiRepository createCutiRepository(CreateCutiRepositoryRef ref) {
  return CreateCutiRepository(
    ref.watch(createCutiRemoteServiceProvider),
  );
}

@riverpod
class JenisCutiNotifier extends _$JenisCutiNotifier {
  @override
  FutureOr<List<JenisCuti>> build() async {
    return ref.read(createCutiRepositoryProvider).getJenisCuti();
  }
}

@riverpod
class AlasanCutiNotifier extends _$AlasanCutiNotifier {
  @override
  FutureOr<List<AlasanCuti>> build() async {
    return ref.read(createCutiRepositoryProvider).getAlasanEmergency();
  }
}

@riverpod
class CreateCutiNotifier extends _$CreateCutiNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> submitCuti({
    required DateTime tglStart,
    required DateTime tglEnd,
    required String keterangan,
    required String jenisCuti,
    required String alasanCuti,
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
      await ref.read(createCutiRepositoryProvider).submitCuti(
            idUser: idUser,
            username: username,
            pass: pass,
            ket: keterangan,
            alasan: alasanCuti,
            jenisCuti: jenisCuti,
            tglEnd: _tglEnd,
            tglStart: _tglStart,
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

  Future<void> updateCuti({
    required int idCuti,
    required DateTime tglStart,
    required DateTime tglEnd,
    required String keterangan,
    required String jenisCuti,
    required String alasanCuti,
    required String hrdNote,
    required String spvNote,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    final _tglStart = DateFormat('yyyy-MM-dd').format(tglStart);
    final _tglEnd = DateFormat('yyyy-MM-dd').format(tglEnd);

    try {
      await ref.read(createCutiRepositoryProvider).updateCuti(
            idCuti: idCuti,
            username: username,
            pass: pass,
            ket: keterangan,
            alasan: alasanCuti,
            jenisCuti: jenisCuti,
            tglEnd: _tglEnd,
            spvNote: spvNote,
            hrdNote: hrdNote,
            tglStart: _tglStart,
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

  Future<void> deleteCuti({
    required int idCuti,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    try {
      await ref.read(createCutiRepositoryProvider).deleteCuti(
            idCuti: idCuti,
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
