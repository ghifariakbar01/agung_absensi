import 'package:face_net_authentication/sakit/sakit_list/infrastructures/sakit_list_remote_service.dart';
import 'package:flutter/material.dart';

import '../application/sakit_list.dart';

class SakitListRepository {
  SakitListRepository(this._remoteService);

  final SakitListRemoteService _remoteService;

  Future<List<SakitList>> getSakitList({
    required String username,
    required String pass,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getSakitList(
      username: username,
      pass: pass,
      dateRange: dateRange,
    );
  }
}
