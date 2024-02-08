import 'dart:developer';

import '../application/cuti_list.dart';
import 'cuti_list_remote_service.dart';

class CutiListRepository {
  CutiListRepository(this._remoteService);

  final CutiListRemoteService _remoteService;

  Future<List<CutiList>> getCutiList({required int page}) {
    return _remoteService.getCutiList(page: page);
  }

  Future<List<CutiList>> getCutiListLimitedAccess(
      {required int page, required int idUserHead}) {
    return _remoteService.getCutiListLimitedAccess(
        page: page, idUserHead: idUserHead);
  }
}
