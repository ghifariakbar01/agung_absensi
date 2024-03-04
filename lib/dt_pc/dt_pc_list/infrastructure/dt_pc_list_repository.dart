import '../application/dt_pc_list.dart';
import 'dt_pc_list_remote_service.dart';

class DtPcListRepository {
  DtPcListRepository(this._remoteService);

  final DtPcListRemoteService _remoteService;

  Future<List<DtPcList>> getDtPcList({required int page}) {
    return _remoteService.getDtPcList(page: page);
  }

  Future<List<DtPcList>> getDtPcListLimitedAccess(
      {required int page, required String staff}) {
    return _remoteService.getDtPcListLimitedAccess(page: page, staff: staff);
  }
}
