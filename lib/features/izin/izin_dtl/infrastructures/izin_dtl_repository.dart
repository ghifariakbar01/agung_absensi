import '../application/izin_dtl.dart';
import 'izin_dtl_remote_service.dart';

class IzinDtlRepository {
  IzinDtlRepository(this._remoteService);

  final IzinDtlRemoteService _remoteService;

  Future<List<IzinDtl>> getIzinDetail({required int idIzin}) {
    return _remoteService.getIzinDetail(idIzin: idIzin);
  }
}
