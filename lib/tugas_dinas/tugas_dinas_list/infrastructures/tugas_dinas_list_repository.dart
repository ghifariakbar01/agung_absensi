import 'package:flutter/material.dart';

import '../application/mst_user_list.dart';
import '../application/tugas_dinas_list.dart';
import 'tugas_dinas_list_remote_service.dart';

class TugasDinasListRepository {
  TugasDinasListRepository(this._remoteService);

  final TugasDinasListRemoteService _remoteService;

  Future<List<TugasDinasList>> getTugasDinasList({
    required String username,
    required String pass,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getTugasDinasList(
      username: username,
      pass: pass,
      dateRange: dateRange,
    );
  }

  Future<List<MstUserList>> getMasterUserList() async {
    return _remoteService.getMasterUserList();
  }
}
