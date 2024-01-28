import 'package:dartz/dartz.dart';

import '../../create_sakit/application/create_sakit.dart';
import '../../sakit_list/application/sakit_list.dart';
import 'sakit_approve_remote_service.dart.dart';

class SakitApproveRepository {
  SakitApproveRepository(this._remoteService);

  final SakitApproveRemoteService _remoteService;

  Future<Unit> approveSpv(
      {required int idSakit, required String nama, required String note}) {
    return _remoteService.approveSpv(idSakit: idSakit, nama: nama, note: note);
  }

  Future<Unit> approveHrd({
    required String nama,
    required String note,
    required SakitList itemSakit,
    required CreateSakit createSakit,
  }) {
    return _remoteService.approveHrd(
        nama: nama, note: note, itemSakit: itemSakit, createSakit: createSakit);
  }

  Future<Unit> unapproveHrd({
    required String nama,
    required SakitList itemSakit,
  }) {
    return _remoteService.unApproveHrd(nama: nama, itemSakit: itemSakit);
  }

  Future<Unit> unapproveSpv({
    required String nama,
    required SakitList itemSakit,
  }) {
    return _remoteService.unApproveSpv(nama: nama, itemSakit: itemSakit);
  }

  Future<Unit> batal({
    required String nama,
    required SakitList itemSakit,
  }) {
    return _remoteService.batal(nama: nama, itemSakit: itemSakit);
  }
}
