import 'package:flutter/material.dart';

import '../application/izin_list.dart';
import '../application/jenis_izin.dart';
import 'izin_list_remote_service.dart';

class IzinListRepository {
  IzinListRepository(this._remoteService);

  final IzinListRemoteService _remoteService;

  Future<List<IzinList>> getIzinList({
    required String username,
    required String pass,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getIzinList(
      username: username,
      pass: pass,
      dateRange: dateRange,
    );
  }

  Future<List<JenisIzin>> getJenisIzin() async {
    return _remoteService.getJenisIzin();
  }
}
