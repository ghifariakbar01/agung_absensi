import 'package:dartz/dartz.dart';

import 'create_izin_remote_service.dart';

class CreateIzinRepository {
  CreateIzinRepository(this._remoteService);

  final CreateIzinRemoteService _remoteService;

  Future<Unit> submitIzin({
    required int idUser,
    required int idMstIzin,
    required int totalHari,
    required String ket,
    required String cUser,
    required String tglEnd,
    required String tglStart,
  }) async {
    return _remoteService.submitIzin(
      idUser: idUser,
      idMstIzin: idMstIzin,
      totalHari: totalHari,
      ket: ket,
      cUser: cUser,
      tglEnd: tglEnd,
      tglStart: tglStart,
    );
  }

  Future<Unit> updateIzin({
    required int id,
    required int idMstIzin,
    required int totalHari,
    required int idUser,
    required String ket,
    required String uUser,
    required String tglEnd,
    required String tglStart,
  }) async {
    return _remoteService.updateIzin(
      id: id,
      idMstIzin: idMstIzin,
      totalHari: totalHari,
      idUser: idUser,
      ket: ket,
      uUser: uUser,
      tglEnd: tglEnd,
      tglStart: tglStart,
    );
  }
}
