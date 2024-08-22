import 'package:dartz/dartz.dart';

import '../../../../constants/constants.dart';
import '../application/absen_ganti_hari.dart';
import 'create_ganti_hari_remote_service.dart';

class CreateGantiHariRepository {
  CreateGantiHariRepository(this._remoteService);

  final CreateGantiHariRemoteService _remoteService;

  Future<Unit> updateGantiHari({
    required int idDayOff,
    required int idUser,
    required int idAbsen,
    required String username,
    required String pass,
    required String ket,
    required String tglOff,
    required String tglGanti,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.updateGantiHari(
      idDayOff: idDayOff,
      idUser: idUser,
      idAbsen: idAbsen,
      username: username,
      pass: pass,
      ket: ket,
      tglOff: tglOff,
      tglGanti: tglGanti,
      server: Constants.isDev ? 'testing' : 'live',
    );
  }

  Future<Unit> submitGantiHari({
    required int idUser,
    required int idAbsen,
    required String username,
    required String pass,
    required String ket,
    required String tglOff,
    required String tglGanti,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.submitGantiHari(
      idUser: idUser,
      idAbsen: idAbsen,
      username: username,
      pass: pass,
      ket: ket,
      tglOff: tglOff,
      tglGanti: tglGanti,
      server: Constants.isDev ? 'testing' : 'live',
    );
  }

  Future<Unit> deleteGantiHari(
      {required String username,
      required String pass,
      required int idDayOff}) async {
    return _remoteService.deleteGantiHari(
      username: username,
      pass: pass,
      idDayOff: idDayOff,
    );
  }

  Future<List<AbsenGantiHari>> getAbsenGantiHari() async {
    return _remoteService.getAbsenGantiHari();
  }
}
