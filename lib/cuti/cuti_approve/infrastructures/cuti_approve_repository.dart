import 'package:dartz/dartz.dart';

import 'cuti_approve_remote_service.dart.dart';

class CutiApproveRepository {
  CutiApproveRepository(this._remoteService);

  final CutiApproveRemoteService _remoteService;

  Future<Unit> approve({
    required int idCuti,
    required String username,
    required String pass,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = 'testing',
  }) async {
    return _remoteService.approve(
      idCuti: idCuti,
      username: username,
      pass: pass,
      jenisApp: jenisApp,
      note: note,
      tahun: tahun,
      server: server,
    );
  }

  Future<Unit> batal({
    required int idCuti,
    required String username,
    required String pass,
  }) async {
    return _remoteService.batal(
      idCuti: idCuti,
      username: username,
      pass: pass,
    );
  }
}
