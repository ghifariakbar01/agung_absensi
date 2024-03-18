import '../application/ganti_hari_list.dart';
import 'ganti_hari_list_remote_service.dart';

class GantiHariListRepository {
  GantiHariListRepository(this._remoteService);

  final GantiHariListRemoteService _remoteService;

  Future<List<GantiHariList>> getGantiHariList({
    required int page,
  }) async {
    return _remoteService.getGantiHariList(
      page: page,
    );
  }

  Future<List<GantiHariList>> getGantiHariListLimitedAccess(
      {required int page, required String staff}) async {
    return _remoteService.getGantiHariListLimitedAccess(
      page: page,
      staff: staff,
    );
  }
}
