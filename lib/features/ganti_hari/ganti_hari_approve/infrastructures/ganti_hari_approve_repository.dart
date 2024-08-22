import 'package:dartz/dartz.dart';

import '../../../../constants/constants.dart';
import 'ganti_hari_approve_remote_service.dart.dart';

class GantiHariApproveRepository {
  GantiHariApproveRepository(this._remoteService);

  final GantiHariApproveRemoteService _remoteService;

  Future<Unit> approve({
    required int idDayOff,
    required String username,
    required String pass,
    required String jenisApp,
    required String note,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.approve(
      idDayOff: idDayOff,
      username: username,
      pass: pass,
      jenisApp: jenisApp,
      note: note,
      server: Constants.isDev ? 'testing' : 'live',
    );
  }

  Future<Unit> batal({
    required int idDayOff,
    required String username,
    required String pass,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.batal(
      idDayOff: idDayOff,
      username: username,
      pass: pass,
    );
  }
}
