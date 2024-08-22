import 'package:dartz/dartz.dart';

import '../../../../constants/constants.dart';
import 'create_dt_pc_remote_service.dart';

class CreateDtPcRepository {
  CreateDtPcRepository(this._remoteService);

  final CreateDtPcRemoteService _remoteService;

  Future<Unit> submitDtPc({
    required int idUser,
    required String username,
    required String pass,
    required String ket,
    required String dtTgl,
    required String jam,
    required String kategori,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.submitDtPc(
      idUser: idUser,
      username: username,
      pass: pass,
      ket: ket,
      dtTgl: dtTgl,
      jam: jam,
      kategori: kategori,
      server: Constants.isDev ? 'testing' : 'live',
    );
  }

  Future<Unit> updateDtPc({
    required int id,
    required int idUser,
    required String username,
    required String pass,
    required String ket,
    required String dtTgl,
    required String jam,
    required String kategori,
    required String noteSpv,
    required String noteHrd,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.updateDtPc(
      id: id,
      idUser: idUser,
      username: username,
      pass: pass,
      ket: ket,
      dtTgl: dtTgl,
      jam: jam,
      kategori: kategori,
      noteSpv: noteSpv,
      noteHrd: noteHrd,
      server: Constants.isDev ? 'testing' : 'live',
    );
  }

  Future<Unit> deleteDtPc({
    required int idDt,
    required String username,
    required String pass,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.deleteDtPc(
      idDt: idDt,
      username: username,
      pass: pass,
      server: Constants.isDev ? 'testing' : 'live',
    );
  }
}
