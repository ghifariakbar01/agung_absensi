import 'package:dartz/dartz.dart';

import 'create_izin_remote_service.dart';

class CreateIzinRepository {
  CreateIzinRepository(this._remoteService);

  final CreateIzinRemoteService _remoteService;

  Future<Unit> submitIzin({
    required String username,
    required String pass,
    required int idUser,
    required int idMstIzin,
    required int totalHari,
    required String ket,
    required String cUser,
    required String tglEnd,
    required String tglStart,
    String? server = 'testing',
  }) async {
    return _remoteService.submitIzin(
      username: username,
      pass: pass,
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
    required int idIzin,
    required String username,
    required String pass,
    required int idUser,
    required int idMstIzin,
    required String ket,
    required String tglEnd,
    required String tglStart,
    required String noteSpv,
    required String noteHrd,
    String? server = 'testing',
  }) async {
    return _remoteService.updateIzin(
      idIzin: idIzin,
      username: username,
      pass: pass,
      idMstIzin: idMstIzin,
      idUser: idUser,
      ket: ket,
      tglEnd: tglEnd,
      tglStart: tglStart,
      noteSpv: noteSpv,
      noteHrd: noteHrd,
    );
  }

  Future<Unit> deleteIzin({
    required String username,
    required String pass,
    required int idIzin,
  }) async {
    return _remoteService.deleteIzin(
      username: username,
      pass: pass,
      idIzin: idIzin,
    );
  }
}
