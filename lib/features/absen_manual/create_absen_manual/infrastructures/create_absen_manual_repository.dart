import 'package:dartz/dartz.dart';

import '../../../../constants/constants.dart';
import '../application/jenis_absen.dart';
import 'create_absen_manual_remote_service.dart';

class CreateAbsenManualRepository {
  CreateAbsenManualRepository(this._remoteService);

  final CreateAbsenManualRemoteService _remoteService;

  Future<Unit> submitAbsenManual({
    required String username,
    required String pass,
    required int idUser,
    required String ket,
    required String tgl,
    required String jamAwal,
    required String jamAkhir,
    required String jenisAbsen,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.submitAbsenManual(
      idUser: idUser,
      ket: ket,
      tgl: tgl,
      jamAwal: jamAwal,
      jamAkhir: jamAkhir,
      jenisAbsen: jenisAbsen,
      username: username,
      pass: pass,
      server: server,
    );
  }

  Future<Unit> updateAbsenManual({
    required String username,
    required String pass,
    required int idUser,
    required int idAbsenmnl,
    required String ket,
    required String tgl,
    required String jamAwal,
    required String jamAkhir,
    required String jenisAbsen,
    required String noteSpv,
    required String noteHrd,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.updateAbsenManual(
      idAbsenmnl: idAbsenmnl,
      idUser: idUser,
      ket: ket,
      username: username,
      pass: pass,
      tgl: tgl,
      jamAwal: jamAwal,
      jamAkhir: jamAkhir,
      jenisAbsen: jenisAbsen,
      noteSpv: noteSpv,
      noteHrd: noteHrd,
    );
  }

  Future<Unit> deleteAbsenmnl({
    required String username,
    required String pass,
    required int idAbsenmnl,
  }) async {
    return _remoteService.deleteAbsenmnl(
      username: username,
      pass: pass,
      idAbsenmnl: idAbsenmnl,
    );
  }

  Future<List<JenisAbsen>> getJenisAbsen() async {
    return _remoteService.getJenisAbsen();
  }
}
