import 'package:dartz/dartz.dart';

import '../../../../constants/constants.dart';

import '../../../ganti_hari/create_ganti_hari/application/absen_ganti_hari.dart';
import 'create_jadwal_shift_remote_service.dart';

class CreateJadwalShiftRepository {
  CreateJadwalShiftRepository(this._remoteService);

  final CreateJadwalShiftRemoteService _remoteService;

  Future<Unit> updateJadwalShift({
    required int idShiftDtl,
    required String username,
    required String pass,
    required String jadwal,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.updateJadwalShift(
      username: username,
      pass: pass,
      idShiftDtl: idShiftDtl,
      jadwal: jadwal,
      server: Constants.isDev ? 'testing' : 'live',
    );
  }

  Future<Unit> submitJadwalShift({
    required int idUser,
    required int week,
    required String username,
    required String pass,
    required DateTime dateTime,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.submitJadwalShift(
      idUser: idUser,
      week: week,
      username: username,
      pass: pass,
      dateTime: dateTime,
      server: Constants.isDev ? 'testing' : 'live',
    );
  }

  Future<Unit> deleteJadwalShift({
    required String username,
    required String pass,
    required int idShift,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    return _remoteService.deleteJadwalShift(
      username: username,
      pass: pass,
      idShift: idShift,
    );
  }

  Future<List<AbsenGantiHari>> getAbsenJadwalShift() async {
    return _remoteService.getAbsenJadwalShift();
  }
}
