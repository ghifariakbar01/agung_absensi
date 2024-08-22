import '../application/sakit_dtl.dart';
import 'sakit_dtl_remote_service.dart';

class SakitDtlRepository {
  SakitDtlRepository(this._remoteService);

  final SakitDtlRemoteService _remoteService;

  Future<List<SakitDtl>> getSakitDetail({required int idSakit}) {
    return _remoteService.getSakitDetail(idSakit: idSakit);
  }
}
