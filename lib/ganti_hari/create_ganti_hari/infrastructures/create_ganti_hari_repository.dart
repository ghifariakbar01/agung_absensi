import 'package:dartz/dartz.dart';

import '../application/absen_ganti_hari.dart';
import 'create_ganti_hari_remote_service.dart';

class CreateGantiHariRepository {
  CreateGantiHariRepository(this._remoteService);

  final CreateGantiHariRemoteService _remoteService;

  Future<Unit> updateGantiHari({
    required int id,
    required int idAbsen,
    required String ket,
    required String tglOff,
    required String tglGanti,
    required String uUser,
  }) async {
    return _remoteService.updateGantiHari(
      id: id,
      idAbsen: idAbsen,
      ket: ket,
      tglOff: tglOff,
      tglGanti: tglGanti,
      uUser: uUser,
    );
  }

  Future<Unit> submitGantiHari({
    required int idUser,
    required int idAbsen,
    required String ket,
    required String tglOff,
    required String tglGanti,
    required String cUser,
  }) async {
    return _remoteService.submitGantiHari(
      idUser: idUser,
      idAbsen: idAbsen,
      ket: ket,
      tglOff: tglOff,
      tglGanti: tglGanti,
      cUser: cUser,
    );
  }

  Future<List<AbsenGantiHari>> getAbsenGantiHari() async {
    return _remoteService.getAbsenGantiHari();
  }
}
