import 'package:dartz/dartz.dart';

import 'absen_manual_approve_remote_service.dart.dart';

class AbsenManualApproveRepository {
  AbsenManualApproveRepository(this._remoteService);

  final AbsenManualApproveRemoteService _remoteService;

  Future<Unit> approveSpv({required int idAbsenMnl, required String nama}) {
    return _remoteService.approveSpv(
      idAbsenMnl: idAbsenMnl,
      nama: nama,
    );
  }

  Future<Unit> unApproveSpv({required int idAbsenMnl, required String nama}) {
    return _remoteService.unApproveSpv(
      idAbsenMnl: idAbsenMnl,
      nama: nama,
    );
  }

  Future<Unit> approveHrd({
    required int idAbsenMnl,
    required String namaHrd,
    required String note,
  }) {
    return _remoteService.approveHrd(
        namaHrd: namaHrd, note: note, idAbsenMnl: idAbsenMnl);
  }

  Future<Unit> unApproveHrd({
    required int idAbsenMnl,
    required String nama,
    required String note,
  }) {
    return _remoteService.unApproveHrd(
        nama: nama, idAbsenMnl: idAbsenMnl, note: note);
  }

  Future<Unit> batal({
    required int idAbsenMnl,
    required String nama,
  }) {
    return _remoteService.batal(nama: nama, idAbsenMnl: idAbsenMnl);
  }
}
