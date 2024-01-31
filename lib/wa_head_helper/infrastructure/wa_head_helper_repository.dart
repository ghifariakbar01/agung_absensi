import '../application/wa_head.dart';
import 'wa_head_helper_remote_service.dart';

class WaHeadHelperRepository {
  WaHeadHelperRepository(this._remoteService);

  final WaHeadHelperRemoteService _remoteService;

  Future<List<WaHead>> getWaHead({
    required int idUser,
  }) {
    return _remoteService.getWaHead(idUser: idUser);
  }
}
