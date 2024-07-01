import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/constants.dart';
import '../../../shared/providers.dart';
import '../../../user/application/user_model.dart';

import '../infrastructures/tugas_dinas_dtl_remote_service.dart';
import '../infrastructures/tugas_dinas_dtl_repository.dart';

import 'tugas_dinas_dtl.dart';

part 'tugas_dinas_dtl_notifier.g.dart';

@Riverpod(keepAlive: true)
TugasDinasDtlRemoteService tugasDinasDtlRemoteService(
    TugasDinasDtlRemoteServiceRef ref) {
  return TugasDinasDtlRemoteService(
    ref.watch(dioProvider),
    ref.watch(dioRequestProvider),
  );
}

@Riverpod(keepAlive: true)
TugasDinasDtlRepository tugasDinasDtlRepository(
    TugasDinasDtlRepositoryRef ref) {
  return TugasDinasDtlRepository(
    ref.watch(tugasDinasDtlRemoteServiceProvider),
  );
}

@riverpod
class TugasDinasDtlNotifier extends _$TugasDinasDtlNotifier {
  @override
  FutureOr<List<TugasDinasDtl>> build() {
    return [];
  }

  Future<void> loadTugasDinasDetail({required int idTugasDinas}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return ref
          .read(tugasDinasDtlRepositoryProvider)
          .getTugasDinasDetail(idTugasDinas: idTugasDinas);
    });
  }

  String urlImageFormTugasDinas(String namaFile) {
    final user = ref.read(userNotifierProvider).user;
    final _url = _determineBaseUrl(user);

    return '$_url/files/$namaFile';
  }

  String formUploadImageFormTugasDinas(int id) {
    final user = ref.read(userNotifierProvider).user;
    final _url = _determineBaseUrl(user);

    final userId = user.idUser;
    final pass = user.password;

    return '$_url/mob_upload.aspx?mode=dinas&noid=$id&userid=$userId&userpass=$pass';
  }

  _determineBaseUrl(UserModelWithPassword user) {
    final pt = user.ptServer;
    if (pt == null) {
      throw AssertionError('pt null');
    }

    return Constants.ptMap.entries
        .firstWhere(
          (element) => element.key == pt,
          orElse: () => Constants.ptMap.entries.first,
        )
        .value
        .replaceAll('/services', '');
  }
}
