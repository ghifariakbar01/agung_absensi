import 'package:face_net_authentication/sakit/sakit_list/infrastructure/sakit_list_remote_service.dart';

import '../application/sakit_list.dart';

class SakitListRepository {
  SakitListRepository(this._remoteService);

  final SakitListRemoteService _remoteService;

  Future<List<SakitList>> getSakitList() {
    return _remoteService.getSakitList();
  }
}
