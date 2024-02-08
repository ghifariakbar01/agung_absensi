import 'package:dartz/dartz.dart';

import '../../cuti_list/application/cuti_list.dart';
import 'cuti_approve_remote_service.dart.dart';

class CutiApproveRepository {
  CutiApproveRepository(this._remoteService);

  final CutiApproveRemoteService _remoteService;

  Future<Unit> approveSpv(
      {required int idCuti, required String nama, required String note}) {
    return _remoteService.approveSpv(idCuti: idCuti, nama: nama, note: note);
  }

  Future<Unit> approveHrd({
    required String nama,
    required String note,
    required CutiList itemCuti,
    // required CreateSakit createSakit,
  }) {
    return _remoteService.approveHrd(
      nama: nama,
      note: note,
      itemCuti: itemCuti,
    );
  }

  // Future<Unit> unApproveHrdDenganSurat({
  //   required String nama,
  //   required SakitList itemSakit,
  // }) {
  //   return _remoteService.unApproveHrdDenganSurat(
  //       nama: nama, itemSakit: itemSakit);
  // }

  // Future<Unit> unapproveSpv({
  //   required String nama,
  //   required SakitList itemSakit,
  // }) {
  //   return _remoteService.unApproveSpv(nama: nama, itemSakit: itemSakit);
  // }

  // Future<Unit> batal({
  //   required String nama,
  //   required SakitList itemSakit,
  // }) {
  //   return _remoteService.batal(nama: nama, itemSakit: itemSakit);
  // }
}
