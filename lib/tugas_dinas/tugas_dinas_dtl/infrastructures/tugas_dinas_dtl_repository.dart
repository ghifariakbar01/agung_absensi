import '../application/tugas_dinas_dtl.dart';
import 'tugas_dinas_dtl_remote_service.dart';

class TugasDinasDtlRepository {
  TugasDinasDtlRepository(this._remoteService);

  final TugasDinasDtlRemoteService _remoteService;

  Future<List<TugasDinasDtl>> getTugasDinasDetail({required int idTugasDinas}) {
    return _remoteService.getTugasDinasDetail(idTugasDinas: idTugasDinas);
  }
}
