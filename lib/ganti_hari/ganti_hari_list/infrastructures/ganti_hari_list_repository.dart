import 'package:flutter/material.dart';

import '../application/ganti_hari_list.dart';
import 'ganti_hari_list_remote_service.dart';

class GantiHariListRepository {
  GantiHariListRepository(this._remoteService);

  final GantiHariListRemoteService _remoteService;

  Future<List<GantiHariList>> getGantiHariList({
    required String username,
    required String pass,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getGantiHariList(
      username: username,
      pass: pass,
      dateRange: dateRange,
    );
  }
}
