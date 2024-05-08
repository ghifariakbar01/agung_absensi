import 'package:flutter/material.dart';

import '../application/cuti_list.dart';
import 'cuti_list_remote_service.dart';

class CutiListRepository {
  CutiListRepository(this._remoteService);

  final CutiListRemoteService _remoteService;

  Future<List<CutiList>> getCutiList({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getCutiList(
      page: page,
      dateRange: dateRange,
      searchUser: searchUser,
    );
  }

  Future<List<CutiList>> getCutiListLimitedAccess({
    required int page,
    required String staff,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getCutiListLimitedAccess(
      page: page,
      staff: staff,
      dateRange: dateRange,
      searchUser: searchUser,
    );
  }
}
