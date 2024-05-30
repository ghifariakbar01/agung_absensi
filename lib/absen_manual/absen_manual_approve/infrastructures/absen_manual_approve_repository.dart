import 'package:dartz/dartz.dart';

import '../../../constants/constants.dart';
import 'absen_manual_approve_remote_service.dart.dart';

class AbsenManualApproveRepository {
  AbsenManualApproveRepository(this._remoteService);

  final AbsenManualApproveRemoteService _remoteService;

  Future<Unit> approve({
    required int idAbsenMnl,
    required String username,
    required String pass,
    required String jenisApp,
    required String note,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.approve(
      idAbsenMnl: idAbsenMnl,
      username: username,
      pass: pass,
      jenisApp: jenisApp,
      note: note,
      server: server,
    );
  }

  Future<Unit> batal({
    required int idAbsenMnl,
    required String username,
    required String pass,
  }) async {
    return _remoteService.batal(
      idAbsenMnl: idAbsenMnl,
      username: username,
      pass: pass,
    );
  }
}
