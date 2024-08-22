import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../shared/providers.dart';
import '../../../user/application/user_model.dart';
import '../infrastructures/izin_dtl_remote_service.dart';
import '../infrastructures/izin_dtl_repository.dart';
import 'izin_dtl.dart';

part 'izin_dtl_notifier.g.dart';

@Riverpod(keepAlive: true)
IzinDtlRemoteService izinDtlRemoteService(IzinDtlRemoteServiceRef ref) {
  return IzinDtlRemoteService(
    ref.watch(dioProvider),
    ref.watch(dioRequestProvider),
  );
}

@Riverpod(keepAlive: true)
IzinDtlRepository izinDtlRepository(IzinDtlRepositoryRef ref) {
  return IzinDtlRepository(
    ref.watch(izinDtlRemoteServiceProvider),
  );
}

@riverpod
class IzinDtlNotifier extends _$IzinDtlNotifier {
  @override
  FutureOr<List<IzinDtl>> build() {
    return [];
  }

  Future<void> loadIzinDetail({required int idIzin}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return ref.read(izinDtlRepositoryProvider).getIzinDetail(idIzin: idIzin);
    });
  }

  // Map<String, String> _imagePtServerMap() => {
  //       'gs_12': '1232',
  //       'gs_14': '1261',
  //       'gs_18': '1026',
  //       'gs_21': '1063',
  //     };

  String urlImageFormIzin(String namaFile) {
    final user = ref.read(userNotifierProvider).user;
    final _url = _determineBaseUrl(user);

    return '$_url/imgizin/$namaFile';
  }

  String formUploadImageFormIzin(int id) {
    final user = ref.read(userNotifierProvider).user;
    final _url = _determineBaseUrl(user);

    final userId = user.idUser;
    final pass = user.password;

    return '$_url/mob_upload.aspx?mode=izin&noid=$id&userid=$userId&userpass=$pass';
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
