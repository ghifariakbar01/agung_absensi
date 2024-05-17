import 'package:dartz/dartz.dart';

import '../application/jenis_absen.dart';
import 'create_absen_manual_remote_service.dart';

class CreateAbsenManualRepository {
  CreateAbsenManualRepository(this._remoteService);

  final CreateAbsenManualRemoteService _remoteService;

  Future<Unit> submitAbsenManual({
    required int idUser,
    required String ket,
    required String tgl,
    required String jamAwal,
    required String jamAkhir,
    required String jenisAbsen,
    required String cUser,
  }) async {
    return _remoteService.submitAbsenManual(
      idUser: idUser,
      ket: ket,
      tgl: tgl,
      jamAwal: jamAwal,
      jamAkhir: jamAkhir,
      jenisAbsen: jenisAbsen,
      cUser: cUser,
    );
  }

  Future<Unit> updateAbsenManual({
    required int id,
    required int idUser,
    required String ket,
    required String tgl,
    required String jamAwal,
    required String jamAkhir,
    required String jenisAbsen,
    required String uUser,
  }) async {
    return _remoteService.updateAbsenManual(
      id: id,
      idUser: idUser,
      ket: ket,
      tgl: tgl,
      jamAwal: jamAwal,
      jamAkhir: jamAkhir,
      jenisAbsen: jenisAbsen,
      uUser: uUser,
    );
  }

  Future<List<JenisAbsen>> getJenisAbsen() async {
    return _remoteService.getJenisAbsen();
  }
}
