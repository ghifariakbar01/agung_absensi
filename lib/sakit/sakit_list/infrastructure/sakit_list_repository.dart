import 'package:face_net_authentication/sakit/sakit_list/infrastructure/sakit_list_remote_service.dart';
import 'package:flutter/material.dart';

import '../application/sakit_list.dart';

class SakitListRepository {
  SakitListRepository(this._remoteService);

  final SakitListRemoteService _remoteService;

  Future<List<SakitList>> getSakitList({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getSakitList(
        page: page, searchUser: searchUser, dateRange: dateRange);
  }

  Future<List<SakitList>> getSakitListLimitedAccess({
    required int page,
    required String staff,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    return _remoteService.getSakitListLimitedAccess(
        page: page, staff: staff, searchUser: searchUser, dateRange: dateRange);
  }
}
