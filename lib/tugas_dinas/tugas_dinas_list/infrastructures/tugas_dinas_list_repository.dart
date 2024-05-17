import 'package:flutter/material.dart';

import '../application/tugas_dinas_list.dart';
import 'tugas_dinas_list_remote_service.dart';

class TugasDinasListRepository {
  TugasDinasListRepository(this._remoteService);

  final TugasDinasListRemoteService _remoteService;

  Future<List<TugasDinasList>> getTugasDinasList({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getTugasDinasList(
        page: page, searchUser: searchUser, dateRange: dateRange);
  }

  Future<List<TugasDinasList>> getTugasDinasListLimitedAccess({
    required int page,
    required String staff,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getTugasDinasListLimitedAccess(
        page: page, staff: staff, searchUser: searchUser, dateRange: dateRange);
  }
}
