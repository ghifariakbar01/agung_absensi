import 'package:dartz/dartz.dart';

import 'err_log_remote_service.dart';

class ErrLogRepository {
  ErrLogRepository(this._remoteService);

  final ErrLogRemoteService _remoteService;

  Future<Unit> sendLog({
    required int idUser,
    required String nama,
    required String imeiDb,
    required String platform,
    required String imeiSaved,
    required String errMessage,
  }) async {
    return _remoteService.sendLog(
        idUser: idUser,
        nama: nama,
        imeiDb: imeiDb,
        platform: platform,
        imeiSaved: imeiSaved,
        errMessage: errMessage);
  }
}
