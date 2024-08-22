import 'package:dartz/dartz.dart';

import '../../../../constants/constants.dart';
import 'dt_pc_approve_remote_service.dart.dart';

class DtPcApproveRepository {
  DtPcApproveRepository(this._remoteService);

  final DtPcApproveRemoteService _remoteService;

  Future<Unit> approve({
    required int idDt,
    required String username,
    required String pass,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.approve(
      idDt: idDt,
      username: username,
      pass: pass,
      jenisApp: jenisApp,
      note: note,
      tahun: tahun,
      server: server,
    );
  }

  Future<Unit> batal({
    required int idDt,
    required String username,
    required String pass,
  }) async {
    return _remoteService.batal(
      idDt: idDt,
      username: username,
      pass: pass,
    );
  }
}
