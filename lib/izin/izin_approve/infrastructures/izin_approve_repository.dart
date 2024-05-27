import 'package:dartz/dartz.dart';

import 'izin_approve_remote_service.dart.dart';

class IzinApproveRepository {
  IzinApproveRepository(this._remoteService);

  final IzinApproveRemoteService _remoteService;

  Future<Unit> approve({
    required int idIzin,
    required String username,
    required String pass,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = 'testing',
  }) async {
    return _remoteService.approve(
      idIzin: idIzin,
      username: username,
      pass: pass,
      jenisApp: jenisApp,
      note: note,
      tahun: tahun,
      server: server,
    );
  }

  Future<Unit> batal({
    required int idIzin,
    required String username,
    required String pass,
  }) async {
    return _remoteService.batal(
      idIzin: idIzin,
      username: username,
      pass: pass,
    );
  }
}
