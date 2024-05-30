import 'package:dartz/dartz.dart';

import '../../../constants/constants.dart';
import 'tugas_dinas_approve_remote_service.dart.dart';

class TugasDinasApproveRepository {
  TugasDinasApproveRepository(this._remoteService);

  final TugasDinasApproveRemoteService _remoteService;

  Future<Unit> approve({
    required int idDinas,
    required String username,
    required String pass,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.approve(
      idDinas: idDinas,
      username: username,
      pass: pass,
      jenisApp: jenisApp,
      note: note,
      tahun: tahun,
      server: server,
    );
  }

  Future<Unit> batal({
    required int idDinas,
    required String username,
    required String pass,
  }) async {
    return _remoteService.batal(
      idDinas: idDinas,
      username: username,
      pass: pass,
    );
  }
}
