import 'package:flutter/material.dart';

import '../application/lembur_list.dart';
import 'lembur_list_remote_service.dart';

class LemburListRepository {
  LemburListRepository(this._remoteService);

  final LemburListRemoteService _remoteService;

  Future<List<LemburList>> getLemburList({
    required String username,
    required String pass,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getLemburList(
      username: username,
      pass: pass,
      dateRange: dateRange,
    );
  }
}
