import '../application/mst_karyawan_cuti.dart';
import 'mst_karyawan_cuti_remote_service.dart';

class MstKaryawanCutiRepository {
  MstKaryawanCutiRepository(this._remoteService);

  final MstKaryawanCutiRemoteService _remoteService;

  Future<MstKaryawanCuti> getSaldoMasterCuti({
    required int idUser,
  }) {
    return _remoteService.getSaldoMasterCuti(
      idUser: idUser,
    );
  }
}
