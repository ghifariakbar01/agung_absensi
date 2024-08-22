import 'package:face_net_authentication/infrastructures/exceptions.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/providers.dart';
import '../infrastructures/create_lembur_remote_service.dart';
import '../infrastructures/create_lembur_repository.dart';

import 'jenis_lembur.dart';

part 'create_lembur_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateLemburRemoteService createLemburRemoteService(
    CreateLemburRemoteServiceRef ref) {
  return CreateLemburRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
CreateLemburRepository createLemburRepository(CreateLemburRepositoryRef ref) {
  return CreateLemburRepository(
    ref.watch(createLemburRemoteServiceProvider),
  );
}

@riverpod
class JenisLemburNotifier extends _$JenisLemburNotifier {
  @override
  FutureOr<List<JenisLembur>> build() async {
    return ref.read(createLemburRepositoryProvider).getJenisLembur();
  }
}

@riverpod
class CreateLemburNotifier extends _$CreateLemburNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> submitLembur({
    required DateTime tgl,
    required DateTime jamAkhir,
    required DateTime jamAwal,
    required String kategori,
    required String keterangan,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;
    final idUser = user.idUser!;

    final _tgl = DateFormat('yyyy-MM-dd').format(tgl);
    final _start = DateFormat('yyyy-MM-dd HH:mm').format(jamAwal);
    final _end = DateFormat('yyyy-MM-dd HH:mm').format(jamAkhir);

    try {
      if (jamAwal.difference(jamAkhir).inDays > 0) {
        await onError('Error Tgl lembur berbeda');
      }

      await ref.read(createLemburRepositoryProvider).submitLembur(
            idUser: idUser,
            username: username,
            pass: pass,
            ket: keterangan,
            tgl: _tgl,
            jamAkhir: _end,
            jamAwal: _start,
            kategori: kategori,
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

  Future<void> updateLembur({
    required int idLembur,
    required DateTime tgl,
    required DateTime jamAkhir,
    required DateTime jamAwal,
    required String kategori,
    required String keterangan,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;
    final idUser = user.idUser!;

    final _tgl = DateFormat('yyyy-MM-dd').format(tgl);
    final _start = DateFormat('yyyy-MM-dd HH:mm').format(jamAwal);
    final _end = DateFormat('yyyy-MM-dd HH:mm').format(jamAkhir);

    try {
      await ref.read(createLemburRepositoryProvider).updateLembur(
            idLembur: idLembur,
            idUser: idUser,
            username: username,
            pass: pass,
            ket: keterangan,
            jamAwal: _start,
            jamAkhir: _end,
            tgl: _tgl,
            kategori: kategori,
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

  Future<void> deleteLembur({
    required int idLembur,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    try {
      await ref.read(createLemburRepositoryProvider).deleteLembur(
            idLembur: idLembur,
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
