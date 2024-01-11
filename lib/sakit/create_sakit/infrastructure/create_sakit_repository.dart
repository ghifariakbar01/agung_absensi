import '../application/create_sakit.dart';
import 'create_sakit_remote_service.dart';

class CreateSakitRepository {
  CreateSakitRepository(this._remoteService);

  final CreateSakitRemoteService _remoteService;

  Future<CreateSakit> getCreateSakit(
      {required int idUser,
      required int idKaryawan,
      required String tglAwal,
      required String tglAkhir}) {
    return _remoteService.getCreateSakit(
      idUser: idUser,
      tglAwal: tglAwal,
      tglAkhir: tglAkhir,
      idKaryawan: idKaryawan,
    );
  }
}
