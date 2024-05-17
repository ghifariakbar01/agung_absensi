import 'package:flutter/material.dart';

import '../application/ganti_hari_list.dart';
import 'ganti_hari_list_remote_service.dart';

class GantiHariListRepository {
  GantiHariListRepository(this._remoteService);

  final GantiHariListRemoteService _remoteService;

  Future<List<GantiHariList>> getGantiHariList({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getGantiHariList(
        page: page, searchUser: searchUser, dateRange: dateRange);
  }

  Future<List<GantiHariList>> getGantiHariListLimitedAccess({
    required int page,
    required String staff,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getGantiHariListLimitedAccess(
        page: page, staff: staff, searchUser: searchUser, dateRange: dateRange);
  }
}
