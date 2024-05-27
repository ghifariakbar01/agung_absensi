import 'package:flutter/material.dart';

import '../application/cuti_list.dart';
import 'cuti_list_remote_service.dart';

class CutiListRepository {
  CutiListRepository(this._remoteService);

  final CutiListRemoteService _remoteService;

  Future<List<CutiList>> getCutiList({
    required String username,
    required String pass,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getCutiList(
      username: username,
      pass: pass,
      dateRange: dateRange,
    );
  }
}
