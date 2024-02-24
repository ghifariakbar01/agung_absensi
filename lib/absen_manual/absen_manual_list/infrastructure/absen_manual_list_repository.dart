import '../application/absen_manual_list.dart';
import 'absen_manual_list_remote_service.dart';

class AbsenManualListRepository {
  AbsenManualListRepository(this._remoteService);

  final AbsenManualListRemoteService _remoteService;

  Future<List<AbsenManualList>> getAbsenManualList({required int page}) {
    return _remoteService.getAbsenManualList(page: page);
  }

  Future<List<AbsenManualList>> getAbsenManualListLimitedAccess(
      {required int page, required int idUserHead}) {
    return _remoteService.getAbsenManualListLimitedAccess(
        page: page, idUserHead: idUserHead);
  }
}
