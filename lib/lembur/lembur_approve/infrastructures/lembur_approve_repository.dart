import 'package:dartz/dartz.dart';

import '../../../constants/constants.dart';

import 'lembur_approve_remote_service.dart';

class LemburApproveRepository {
  LemburApproveRepository(this._remoteService);

  final LemburApproveRemoteService _remoteService;

  Future<Unit> approve({
    required int idLembur,
    required String username,
    required String pass,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.approve(
      idLembur: idLembur,
      username: username,
      pass: pass,
      jenisApp: jenisApp,
      note: note,
      tahun: tahun,
      server: server,
    );
  }

  Future<Unit> batal({
    required int idLembur,
    required String username,
    required String pass,
  }) async {
    return _remoteService.batal(
      idLembur: idLembur,
      username: username,
      pass: pass,
    );
  }
}
