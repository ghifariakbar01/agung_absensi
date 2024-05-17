import 'package:dartz/dartz.dart';

import 'izin_approve_remote_service.dart.dart';

class IzinApproveRepository {
  IzinApproveRepository(this._remoteService);

  final IzinApproveRemoteService _remoteService;

  Future<Unit> approveSpv({required int idIzin, required String nama}) {
    return _remoteService.approveSpv(
      idIzin: idIzin,
      nama: nama,
    );
  }

  Future<Unit> unApproveSpv({required int idIzin, required String nama}) {
    return _remoteService.unApproveSpv(
      idIzin: idIzin,
      nama: nama,
    );
  }

  Future<Unit> approveHrd({
    required int idIzin,
    required String namaHrd,
    required String note,
  }) {
    return _remoteService.approveHrd(
        namaHrd: namaHrd, note: note, idIzin: idIzin);
  }

  Future<Unit> unApproveHrd({
    required int idIzin,
    required String nama,
    required String note,
  }) {
    return _remoteService.unApproveHrd(nama: nama, idIzin: idIzin, note: note);
  }

  Future<Unit> batal({
    required int idIzin,
    required String nama,
  }) {
    return _remoteService.batal(nama: nama, idIzin: idIzin);
  }
}
