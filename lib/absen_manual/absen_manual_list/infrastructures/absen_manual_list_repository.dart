import 'package:flutter/material.dart';

import '../application/absen_manual_list.dart';
import 'absen_manual_list_remote_service.dart';

class AbsenManualListRepository {
  AbsenManualListRepository(this._remoteService);

  final AbsenManualListRemoteService _remoteService;

  Future<List<AbsenManualList>> getAbsenManualList({
    required String username,
    required String pass,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getAbsenManualList(
      username: username,
      pass: pass,
      dateRange: dateRange,
    );
  }
}
