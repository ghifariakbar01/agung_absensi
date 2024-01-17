import 'package:dartz/dartz.dart';

import 'sakit_approve_remote_service.dart.dart';

class SakitApproveRepository {
  SakitApproveRepository(this._remoteService);

  final SakitApproveRemoteService _remoteService;

  Future<Unit> approveSpv(
      {required int idSakit, required String nama, required String note}) {
    return _remoteService.approveSpv(idSakit: idSakit, nama: nama, note: note);
  }
}
