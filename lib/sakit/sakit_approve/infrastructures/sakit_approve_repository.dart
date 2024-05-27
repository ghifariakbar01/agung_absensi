import 'package:dartz/dartz.dart';

import 'sakit_approve_remote_service.dart.dart';

class SakitApproveRepository {
  SakitApproveRepository(this._remoteService);

  final SakitApproveRemoteService _remoteService;

  Future<Unit> approve({
    required int idSakit,
    required String username,
    required String pass,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = 'testing',
  }) async {
    return _remoteService.approve(
      idSakit: idSakit,
      username: username,
      pass: pass,
      jenisApp: jenisApp,
      note: note,
      tahun: tahun,
      server: server,
    );
  }

  Future<Unit> batal({
    required int idSakit,
    required String username,
    required String pass,
  }) async {
    return _remoteService.batal(
      idSakit: idSakit,
      username: username,
      pass: pass,
    );
  }
}
