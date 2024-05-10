import 'package:flutter/material.dart';

import '../application/dt_pc_list.dart';
import 'dt_pc_list_remote_service.dart';

class DtPcListRepository {
  DtPcListRepository(this._remoteService);

  final DtPcListRemoteService _remoteService;

  Future<List<DtPcList>> getDtPcList({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getDtPcList(
      page: page,
      dateRange: dateRange,
      searchUser: searchUser,
    );
  }

  Future<List<DtPcList>> getDtPcListLimitedAccess({
    required int page,
    required String staff,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getDtPcListLimitedAccess(
      page: page,
      staff: staff,
      dateRange: dateRange,
      searchUser: searchUser,
    );
  }
}
