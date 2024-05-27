// import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../application/alasan_cuti.dart';
import '../application/jenis_cuti.dart';
import 'create_cuti_remote_service.dart';

// import '../application/sakit_list.dart';

class CreateCutiRepository {
  CreateCutiRepository(this._remoteService);

  final CreateCutiRemoteService _remoteService;

  Future<Unit> updateCuti({
    required String username,
    required String pass,
    required int idCuti,
    required String jenisCuti,
    required String alasan,
    required String ket,
    required String tglStart,
    required String tglEnd,
  }) async {
    return _remoteService.updateCuti(
      idCuti: idCuti,
      username: username,
      pass: pass,
      jenisCuti: jenisCuti,
      ket: ket,
      alasan: alasan,
      tglStart: tglStart,
      tglEnd: tglEnd,
    );
  }

  Future<Unit> submitCuti({
    required String username,
    required String pass,
    required int idUser,
    required String jenisCuti,
    required String alasan,
    required String ket,
    required String tglStart,
    required String tglEnd,
  }) async {
    return _remoteService.submitCuti(
      idUser: idUser,
      username: username,
      pass: pass,
      jenisCuti: jenisCuti,
      ket: ket,
      alasan: alasan,
      tglStart: tglStart,
      tglEnd: tglEnd,
    );
  }

  Future<Unit> deleteCuti({
    required String username,
    required String pass,
    required int idCuti,
  }) async {
    return _remoteService.deleteCuti(
      username: username,
      pass: pass,
      idCuti: idCuti,
    );
  }

  Future<List<AlasanCuti>> getAlasanEmergency() {
    return _remoteService.getAlasanEmergency();
  }

  Future<List<JenisCuti>> getJenisCuti() {
    return _remoteService.getJenisCuti();
  }
}
