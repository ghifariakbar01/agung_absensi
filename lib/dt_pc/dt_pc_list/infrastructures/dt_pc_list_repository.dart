import 'package:flutter/material.dart';

import '../application/dt_pc_list.dart';
import 'dt_pc_list_remote_service.dart';

class DtPcListRepository {
  DtPcListRepository(this._remoteService);

  final DtPcListRemoteService _remoteService;

  Future<List<DtPcList>> getDtPcList({
    required String username,
    required String pass,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getDtPcList(
      username: username,
      pass: pass,
      dateRange: dateRange,
    );
  }
}
