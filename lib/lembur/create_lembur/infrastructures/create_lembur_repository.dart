// import 'package:face_net_authentication/utils/logging.dart';

import 'package:dartz/dartz.dart';

import '../../../constants/constants.dart';
import '../application/jenis_lembur.dart';
import 'create_lembur_remote_service.dart';

class CreateLemburRepository {
  CreateLemburRepository(this._remoteService);

  final CreateLemburRemoteService _remoteService;

  Future<Unit> updateLembur({
    required int idLembur,
    required String username,
    required String pass,
    required int idUser,
    required String jamAkhir,
    required String jamAwal,
    required String kategori,
    required String tgl,
    required String ket,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.updateLembur(
      idLembur: idLembur,
      username: username,
      pass: pass,
      idUser: idUser,
      ket: ket,
      jamAkhir: jamAkhir,
      jamAwal: jamAwal,
      kategori: kategori,
      tgl: tgl,
    );
  }

  Future<Unit> submitLembur({
    required String username,
    required String pass,
    required int idUser,
    required String jamAkhir,
    required String jamAwal,
    required String kategori,
    required String tgl,
    required String ket,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.submitLembur(
      idUser: idUser,
      username: username,
      pass: pass,
      tgl: tgl,
      ket: ket,
      jamAkhir: jamAkhir,
      jamAwal: jamAwal,
      kategori: kategori,
    );
  }

  Future<Unit> deleteLembur({
    required String username,
    required String pass,
    required int idLembur,
  }) async {
    return _remoteService.deleteLembur(
      username: username,
      pass: pass,
      idLembur: idLembur,
    );
  }

  Future<List<JenisLembur>> getJenisLembur() {
    return _remoteService.getJenisLembur();
  }
}
