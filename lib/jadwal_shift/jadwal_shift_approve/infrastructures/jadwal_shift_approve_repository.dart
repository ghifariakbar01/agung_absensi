import 'package:dartz/dartz.dart';

import '../../../constants/constants.dart';

import 'jadwal_shift_approve_remote_service.dart.dart';

class JadwalShiftApproveRepository {
  JadwalShiftApproveRepository(this._remoteService);

  final JadwalShiftApproveRemoteService _remoteService;

  Future<Unit> approve({
    required int idShift,
    required String username,
    required String pass,
    required String jenisApp,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.approve(
      idShift: idShift,
      username: username,
      pass: pass,
      jenisApp: jenisApp,
      server: Constants.isDev ? 'testing' : 'live',
    );
  }

  Future<Unit> batal({
    required int idShift,
    required String username,
    required String pass,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.batal(
      idShift: idShift,
      username: username,
      pass: pass,
    );
  }
}
