import 'package:dartz/dartz.dart';

import '../../ganti_hari_list/application/ganti_hari_list.dart';
import 'ganti_hari_approve_remote_service.dart.dart';

class GantiHariApproveRepository {
  GantiHariApproveRepository(this._remoteService);

  final GantiHariApproveRemoteService _remoteService;

  Future<Unit> approveSpv({
    required int idDayOff,
    required String nama,
  }) async {
    return _remoteService.approveSpv(
      idDayOff: idDayOff,
      nama: nama,
    );
  }

  Future<Unit> unapproveSpv({
    required int idDayOff,
    required String nama,
  }) async {
    return _remoteService.unapproveSpv(
      idDayOff: idDayOff,
      nama: nama,
    );
  }

  Future<Unit> approveHrd({
    required String nama,
    required String note,
    required GantiHariList itemGantiHari,
  }) async {
    return _remoteService.approveHrd(
      nama: nama,
      note: note,
      itemGantiHari: itemGantiHari,
    );
  }

  Future<Unit> unapproveHrd({
    required String nama,
    required GantiHariList itemGantiHari,
  }) async {
    return _remoteService.unapproveHrd(
      nama: nama,
      itemGantiHari: itemGantiHari,
    );
  }

  Future<Unit> batal({
    required String nama,
    required GantiHariList itemGantiHari,
  }) async {
    return _remoteService.batal(
      nama: nama,
      itemGantiHari: itemGantiHari,
    );
  }
}
