import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../infrastructure/sakit_dtl_remote_service.dart';
import '../infrastructure/sakit_dtl_repository.dart';
import 'sakit_dtl.dart';

part 'sakit_dtl_notifier.g.dart';

@Riverpod(keepAlive: true)
SakitDtlRemoteService sakitDtlRemoteService(SakitDtlRemoteServiceRef ref) {
  return SakitDtlRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
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
  FutureOr<SakitDtl> build() {
    return SakitDtl.initial();
  }

  Future<void> loadSakitDetail({required int idSakit}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return ref
          .read(sakitDtlRepositoryProvider)
          .getSakitDetail(idSakit: idSakit);
    });
  }

  Map<String, String> _imagePtServerMap() =>
      {'gs_12': '1232', 'gs_14': '1261', 'gs_18': '1026', 'gs_21': '1063'};

  String urlImageFormSakit(String namaFile) {
    final ptServer =
        ref.read(userNotifierProvider.select((value) => value.user.ptServer));

    final port = _imagePtServerMap()
        .entries
        .toList()
        .firstWhere((element) => element.key == ptServer)
        .value;

    return 'http://agunglogisticsapp.co.id:$port/imgsakit/$namaFile';
  }

  String formUploadImageFormSakit(int id) {
    final user = ref.read(userNotifierProvider).user;

    final ptServer = user.ptServer;
    final userId = user.idUser;
    final pass = user.password;

    final port = _imagePtServerMap()
        .entries
        .toList()
        .firstWhere((element) => element.key == ptServer)
        .value;

    return 'http://agunglogisticsapp.co.id:$port/mob_upload.aspx?mode=sakit&noid=$id&userid=$userId&userpass=$pass';
  }
}
