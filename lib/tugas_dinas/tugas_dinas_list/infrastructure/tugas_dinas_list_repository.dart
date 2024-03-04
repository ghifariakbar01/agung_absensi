import '../application/tugas_dinas_list.dart';
import 'tugas_dinas_list_remote_service.dart';

class TugasDinasListRepository {
  TugasDinasListRepository(this._remoteService);

  final TugasDinasListRemoteService _remoteService;

  Future<List<TugasDinasList>> getTugasDinasList({required int page}) {
    return _remoteService.getTugasDinasList(page: page);
  }

  Future<List<TugasDinasList>> getTugasDinasListLimitedAccess(
      {required int page, required String staff}) {
    return _remoteService.getTugasDinasListLimitedAccess(
        page: page, staff: staff);
  }
}
