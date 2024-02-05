import 'package:dartz/dartz.dart';

import '../application/create_sakit.dart';
import '../application/create_sakit_cuti.dart';
import 'create_sakit_remote_service.dart';

class CreateSakitRepository {
  CreateSakitRepository(this._remoteService);

  final CreateSakitRemoteService _remoteService;

  Future<Unit> submitSakit({
    required int idUser,
    required String ket,
    required String surat,
    required String cUser,
    required String tglEnd,
    required String tglStart,
    required String jumlahHari,
  }) {
    return _remoteService.submitSakit(
      idUser: idUser,
      ket: ket,
      surat: surat,
      cUser: cUser,
      tglEnd: tglEnd,
      tglStart: tglStart,
      jumlahHari: jumlahHari,
    );
  }

  Future<Unit> updateSakit({
    required int id,
    required int idUser,
    required String ket,
    required String surat,
    required String cUser,
    required String tglEnd,
    required String tglStart,
    required int jumlahHari,
    required int hitungLibur,
  }) {
    return _remoteService.updateSakit(
        id: id,
        idUser: idUser,
        ket: ket,
        surat: surat,
        cUser: cUser,
        tglEnd: tglEnd,
        tglStart: tglStart,
        jumlahHari: jumlahHari,
        hitungLibur: hitungLibur);
  }

  Future<int> getLastSubmitSakit({required int idUser}) {
    return _remoteService.getLastSubmitSakit(idUser: idUser);
  }

  Future<CreateSakit> getCreateSakit(
      {required int idUser,
      required int idKaryawan,
      required String tglAwal,
      required String tglAkhir}) {
    return _remoteService.getCreateSakit(
      idUser: idUser,
      tglAwal: tglAwal,
      tglAkhir: tglAkhir,
      idKaryawan: idKaryawan,
    );
  }

  Future<CreateSakitCuti> getSaldoMasterCuti({
    required int idUser,
  }) {
    return _remoteService.getSaldoMasterCuti(
      idUser: idUser,
    );
  }
}
