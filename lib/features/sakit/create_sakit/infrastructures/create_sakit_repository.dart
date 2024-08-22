import 'package:dartz/dartz.dart';

import '../../../../constants/constants.dart';
import 'create_sakit_remote_service.dart';

class CreateSakitRepository {
  CreateSakitRepository(this._remoteService);

  final CreateSakitRemoteService _remoteService;

  Future<Unit> submitSakit({
    required String username,
    required String pass,
    required int idUser,
    required String tglStart,
    required String tglEnd,
    required String ket,
    required String surat,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.submitSakit(
      username: username,
      pass: pass,
      idUser: idUser,
      tglStart: tglStart,
      tglEnd: tglEnd,
      ket: ket,
      surat: surat,
      server: server,
    );
  }

  Future<Unit> updateSakit({
    required int idSakit,
    required String username,
    required String pass,
    required int idUser,
    required String tglStart,
    required String tglEnd,
    required String ket,
    required String surat,
    required String noteSpv,
    required String noteHrd,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.updateSakit(
      idSakit: idSakit,
      username: username,
      pass: pass,
      idUser: idUser,
      tglStart: tglStart,
      tglEnd: tglEnd,
      ket: ket,
      surat: surat,
      noteSpv: noteSpv,
      noteHrd: noteHrd,
      server: server,
    );
  }

  Future<Unit> deleteSakit({
    required int idSakit,
    required String username,
    required String pass,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.deleteSakit(
      idSakit: idSakit,
      username: username,
      pass: pass,
      server: server,
    );
  }
}
