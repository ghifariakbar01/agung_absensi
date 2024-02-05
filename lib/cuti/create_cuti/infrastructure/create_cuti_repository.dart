import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../application/alasan_cuti.dart';
import '../application/jenis_cuti.dart';
import 'create_cuti_remote_service.dart';

// import '../application/sakit_list.dart';

class CreateCutiRepository {
  CreateCutiRepository(this._remoteService);

  final CreateCutiRemoteService _remoteService;

  Future<Unit> submitCuti({
    required String jenisCuti,
    required String alasan,
    required String ket,
    required String tahunCuti,
    required int idUser,
    required int totalHari,
    required int sisaCuti,
    // date time
    required DateTime tglAwalInDateTime,
    required DateTime tglAkhirInDateTime,
  }) async {
    // return _remoteService.submitCuti(
    //     jenisCuti: jenisCuti,
    //     alasan: alasan,
    //     ket: ket,
    //     tahunCuti: tahunCuti,
    //     idUser: idUser,
    //     totalHari: totalHari,
    //     sisaCuti: sisaCuti,
    //     // date time
    //     tglAwalInDateTime: tglAwalInDateTime,
    //     tglAkhirInDateTime: tglAkhirInDateTime);

    debugger();
    return unit;
  }

  Future<List<AlasanCuti>> getAlasanEmergency() {
    return _remoteService.getAlasanEmergency();
  }

  Future<List<JenisCuti>> getJenisCuti() {
    return _remoteService.getJenisCuti();
  }
}
