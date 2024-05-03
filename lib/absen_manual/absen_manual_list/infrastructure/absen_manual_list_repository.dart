import 'package:flutter/material.dart';

import '../application/absen_manual_list.dart';
import 'absen_manual_list_remote_service.dart';

class AbsenManualListRepository {
  AbsenManualListRepository(this._remoteService);

  final AbsenManualListRemoteService _remoteService;

  Future<List<AbsenManualList>> getAbsenManualList({
    required int page,
    required String staff,
    required String searchUser,
    required DateTimeRange dateRange,
  }) {
    return _remoteService.getAbsenManualList(
        page: page, staff: staff, searchUser: searchUser, dateRange: dateRange);
  }

  Future<List<AbsenManualList>> getAbsenManualListLimitedAccess({
    required int page,
    required String staff,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getAbsenManualListLimitedAccess(
        page: page, staff: staff, searchUser: searchUser, dateRange: dateRange);
  }
}
