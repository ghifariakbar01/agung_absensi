import 'package:dartz/dartz.dart';

import '../application/jenis_tugas_dinas.dart';
import '../application/user_list.dart';
import 'create_tugas_dinas_remote_service.dart';

class CreateTugasDinasRepository {
  CreateTugasDinasRepository(this._remoteService);

  final CreateTugasDinasRemoteService _remoteService;

  Future<Unit> submitTugasDinas({
    required int idUser,
    required int idPemberi,
    required String ket,
    required String tglAwal,
    required String tglAkhir,
    required String jamAwal,
    required String jamAkhir,
    required String kategori,
    required String perusahaan,
    required String lokasi,
    required String cUser,
    required bool khusus,
  }) async {
    return _remoteService.submitTugasDinas(
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
        cUser: cUser,
        khusus: khusus);
  }

  Future<Unit> updateTugasDinas({
    required int id,
    required int idUser,
    required int idPemberi,
    required String ket,
    required String tglAwal,
    required String tglAkhir,
    required String jamAwal,
    required String jamAkhir,
    required String kategori,
    required String perusahaan,
    required String lokasi,
    required bool khusus,
    required String uUser,
  }) async {
    return _remoteService.updateTugasDinas(
      id: id,
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
      khusus: khusus,
      uUser: uUser,
    );
  }

  Future<List<JenisTugasDinas>> getJenisTugasDinas() async {
    return _remoteService.getJenisTugasDinas();
  }

  Future<List<UserList>> getPemberiTugasListNamed(String name) async {
    return _remoteService.getPemberiTugasListNamed(name);
  }
}
