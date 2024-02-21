import 'package:dartz/dartz.dart';

import 'create_dt_pc_remote_service.dart';

class CreateDtPcRepository {
  CreateDtPcRepository(this._remoteService);

  final CreateDtPcRemoteService _remoteService;

  Future<Unit> submitDtPc({
    required int idUser,
    required String ket,
    required String dtTgl,
    required String jam,
    required String kategori,
    required String cUser,
  }) async {
    return _remoteService.submitDtPc(
        idUser: idUser,
        ket: ket,
        cUser: cUser,
        dtTgl: dtTgl,
        jam: jam,
        kategori: kategori);
  }

  Future<Unit> updateDtPc({
    required int id,
    required int idUser,
    required String ket,
    required String dtTgl,
    required String jam,
    required String kategori,
    required String uUser,
  }) async {
    return _remoteService.updateDtPc(
      id: id,
      idUser: idUser,
      ket: ket,
      uUser: uUser,
      dtTgl: dtTgl,
      jam: jam,
      kategori: kategori,
    );
  }
}
