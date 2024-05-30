import 'package:dartz/dartz.dart';

import '../../../constants/constants.dart';
import '../application/jenis_tugas_dinas.dart';
import '../application/user_list.dart';
import 'create_tugas_dinas_remote_service.dart';

class CreateTugasDinasRepository {
  CreateTugasDinasRepository(this._remoteService);

  final CreateTugasDinasRemoteService _remoteService;

  Future<Unit> submitTugasDinas({
    required int idUser,
    required int idPemberi,
    required String username,
    required String pass,
    required String ket,
    required String tglAwal,
    required String tglAkhir,
    required String jamAwal,
    required String jamAkhir,
    required String kategori,
    required String perusahaan,
    required String lokasi,
    required bool jenis,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.submitTugasDinas(
      idUser: idUser,
      username: username,
      pass: pass,
      idPemberi: idPemberi,
      ket: ket,
      tglAwal: tglAwal,
      tglAkhir: tglAkhir,
      jamAwal: jamAwal,
      jamAkhir: jamAkhir,
      kategori: kategori,
      perusahaan: perusahaan,
      lokasi: lokasi,
      jenis: jenis,
      server: server,
    );
  }

  Future<Unit> updateTugasDinas({
    required int idDinas,
    required int idUser,
    required int idPemberi,
    required String username,
    required String pass,
    required String ket,
    required String tglAwal,
    required String tglAkhir,
    required String jamAwal,
    required String jamAkhir,
    required String kategori,
    required String perusahaan,
    required String lokasi,
    required bool jenis,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.updateTugasDinas(
      idDinas: idDinas,
      idUser: idUser,
      idPemberi: idPemberi,
      ket: ket,
      tglAwal: tglAwal,
      tglAkhir: tglAkhir,
      jamAwal: jamAwal,
      jamAkhir: jamAkhir,
      kategori: kategori,
      perusahaan: perusahaan,
      lokasi: lokasi,
      username: username,
      pass: pass,
      jenis: jenis,
      server: server,
    );
  }

  Future<List<JenisTugasDinas>> getJenisTugasDinas() async {
    return _remoteService.getJenisTugasDinas();
  }

  Future<List<UserList>> getPemberiTugasListNamed(String name) async {
    return _remoteService.getPemberiTugasListNamed(name);
  }

  Future<Unit> deleteTugasDinas({
    required int idDinas,
    required String username,
    required String pass,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.deleteTugasDinas(
      idDinas: idDinas,
      username: username,
      pass: pass,
    );
  }
}
