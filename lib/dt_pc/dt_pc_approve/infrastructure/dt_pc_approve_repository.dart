import 'package:dartz/dartz.dart';

import 'dt_pc_approve_remote_service.dart.dart';

class DtPcApproveRepository {
  DtPcApproveRepository(this._remoteService);

  final DtPcApproveRemoteService _remoteService;

  Future<Unit> approveSpv({required int idDt, required String nama}) {
    return _remoteService.approveSpv(
      idDt: idDt,
      nama: nama,
    );
  }

  Future<Unit> unApproveSpv({required int idDt, required String nama}) {
    return _remoteService.unApproveSpv(
      idDt: idDt,
      nama: nama,
    );
  }

  Future<Unit> approveHrd({
    required int idDt,
    required String namaHrd,
    required String note,
  }) {
    return _remoteService.approveHrd(namaHrd: namaHrd, note: note, idDt: idDt);
  }

  Future<Unit> unApproveHrd({
    required int idDt,
    required String nama,
    required String note,
  }) {
    return _remoteService.unApproveHrd(nama: nama, idDt: idDt, note: note);
  }

  Future<Unit> batal({
    required int idDt,
    required String nama,
  }) {
    return _remoteService.batal(nama: nama, idDt: idDt);
  }
}
