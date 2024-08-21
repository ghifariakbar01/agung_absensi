import '../application/jadwal_shift_detail.dart';
import '../application/jadwal_shift_list.dart';
import 'jadwal_shift_list_remote_service.dart';

class JadwalShiftListRepository {
  JadwalShiftListRepository(this._remoteService);

  final JadwalShiftListRemoteService _remoteService;

  Future<List<JadwalShiftDetail>> getJadwalShiftDetail({
    required int idShift,
    required String username,
    required String pass,
  }) async {
    return _remoteService.getJadwalShiftDetail(
      username: username,
      pass: pass,
      idShift: idShift,
    );
  }

  Future<List<JadwalShiftList>> getJadwalShiftList({
    required String username,
    required String pass,
  }) async {
    return _remoteService.getJadwalShiftList(
      username: username,
      pass: pass,
    );
  }
}
