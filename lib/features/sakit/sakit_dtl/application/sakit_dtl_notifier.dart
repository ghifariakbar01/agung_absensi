import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../shared/providers.dart';
import '../../../user/application/user_model.dart';
import '../infrastructures/sakit_dtl_remote_service.dart';
import '../infrastructures/sakit_dtl_repository.dart';
import 'sakit_dtl.dart';

part 'sakit_dtl_notifier.g.dart';

@Riverpod(keepAlive: true)
SakitDtlRemoteService sakitDtlRemoteService(SakitDtlRemoteServiceRef ref) {
  return SakitDtlRemoteService(
    ref.watch(dioProvider),
    ref.watch(dioRequestProvider),
  );
}

@Riverpod(keepAlive: true)
SakitDtlRepository sakitDtlRepository(SakitDtlRepositoryRef ref) {
  return SakitDtlRepository(
    ref.watch(sakitDtlRemoteServiceProvider),
  );
}

@riverpod
class SakitDtlNotifier extends _$SakitDtlNotifier {
  @override
  FutureOr<List<SakitDtl>> build() {
    return [];
  }

  Future<void> loadSakitDetail({required int idSakit}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return ref
          .read(sakitDtlRepositoryProvider)
          .getSakitDetail(idSakit: idSakit);
    });
  }

  // Map<String, String> _imagePtServerMap() => {
  //       'gs_12': '1232',
  //       'gs_14': '1261',
  //       'gs_18': '1026',
  //       'gs_21': '1063',
  //     };

  String urlImageFormSakit(String namaFile) {
    final user = ref.read(userNotifierProvider).user;
    final _url = _determineBaseUrl(user);

    return '$_url/imgsakit/$namaFile';
  }

  String formUploadImageFormSakit(int id) {
    final user = ref.read(userNotifierProvider).user;
    final _url = _determineBaseUrl(user);

    final userId = user.idUser;
    final pass = user.password;

    return '$_url/mob_upload.aspx?mode=sakit&noid=$id&userid=$userId&userpass=$pass';
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
