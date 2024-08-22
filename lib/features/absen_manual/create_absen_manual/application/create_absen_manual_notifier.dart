import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../infrastructures/exceptions.dart';
import '../../../../shared/providers.dart';

import '../infrastructures/create_absen_manual_remote_service.dart';
import '../infrastructures/create_absen_manual_repository.dart';
import 'jenis_absen.dart';

part 'create_absen_manual_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateAbsenManualRemoteService createAbsenManualRemoteService(
    CreateAbsenManualRemoteServiceRef ref) {
  return CreateAbsenManualRemoteService(
    ref.watch(dioProviderCuti),
  );
}

@Riverpod(keepAlive: true)
CreateAbsenManualRepository createAbsenManualRepository(
    CreateAbsenManualRepositoryRef ref) {
  return CreateAbsenManualRepository(
    ref.watch(createAbsenManualRemoteServiceProvider),
  );
}

@riverpod
class JenisAbsenManualNotifier extends _$JenisAbsenManualNotifier {
  @override
  FutureOr<List<JenisAbsen>> build() async {
    return ref.read(createAbsenManualRepositoryProvider).getJenisAbsen();
  }
}

@riverpod
class CreateAbsenManualNotifier extends _$CreateAbsenManualNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> submitAbsenManual({
    required int idUser,
    required String ket,
    required String tgl,
    required String jamAwal,
    required String jamAkhir,
    required String jenisAbsen,
    required String cUser,
    required Future<void> Function(String errMessage) onError,
  }) async {
    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    state = const AsyncLoading();

    try {
      await ref.read(createAbsenManualRepositoryProvider).submitAbsenManual(
            idUser: idUser,
            ket: ket,
            tgl: tgl,
            jamAwal: jamAwal,
            jamAkhir: jamAkhir,
            jenisAbsen: jenisAbsen,
            username: username,
            pass: pass,
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

  Future<void> updateAbsenManual({
    required int idAbsenmnl,
    required String ket,
    required String tgl,
    required String jamAwal,
    required String jamAkhir,
    required String jenisAbsen,
    required String noteSpv,
    required String noteHrd,
    String? server = Constants.isDev ? 'testing' : 'live',
    required Future<void> Function(String errMessage) onError,
  }) async {
    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;
    final idUser = user.idUser!;

    state = const AsyncLoading();

    try {
      await ref.read(createAbsenManualRepositoryProvider).updateAbsenManual(
            idAbsenmnl: idAbsenmnl,
            username: username,
            pass: pass,
            idUser: idUser,
            ket: ket,
            tgl: tgl,
            jamAwal: jamAwal,
            jamAkhir: jamAkhir,
            jenisAbsen: jenisAbsen,
            noteSpv: noteSpv,
            noteHrd: noteHrd,
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

  Future<void> deleteAbsenmanual({
    required int idAbsenmnl,
    required Future<void> Function(String errMessage) onError,
  }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;
    final username = user.nama!;
    final pass = user.password!;

    try {
      await ref.read(createAbsenManualRepositoryProvider).deleteAbsenmnl(
            idAbsenmnl: idAbsenmnl,
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
