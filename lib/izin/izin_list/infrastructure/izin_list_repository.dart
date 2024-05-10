import 'package:flutter/material.dart';

import '../application/izin_list.dart';
import '../application/jenis_izin.dart';
import 'izin_list_remote_service.dart';

class IzinListRepository {
  IzinListRepository(this._remoteService);

  final IzinListRemoteService _remoteService;

  Future<List<IzinList>> getIzinList({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getIzinList(
        page: page, dateRange: dateRange, searchUser: searchUser);
  }

  Future<List<IzinList>> getIzinListLimitedAccess({
    required int page,
    required String staff,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getIzinListLimitedAccess(
        page: page, staff: staff, searchUser: searchUser, dateRange: dateRange);
  }

  Future<List<JenisIzin>> getJenisIzin() async {
    return _remoteService.getJenisIzin();
  }
}
