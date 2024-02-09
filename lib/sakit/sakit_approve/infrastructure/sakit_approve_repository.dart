import 'package:dartz/dartz.dart';

import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
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

  Future<Unit> approveHrdTanpaSurat({
    required String nama,
    required String note,
    required SakitList itemSakit,
    required CreateSakit createSakit,
    required MstKaryawanCuti mstCuti,
  }) {
    return _remoteService.approveHrdTanpaSurat(
      nama: nama,
      note: note,
      itemSakit: itemSakit,
      createSakit: createSakit,
      mstCuti: mstCuti,
    );
  }

  Future<Unit> approveHrdDenganSurat({
    required String nama,
    required String note,
    required SakitList itemSakit,
  }) {
    return _remoteService.approveHrdDenganSurat(
      nama: nama,
      note: note,
      itemSakit: itemSakit,
    );
  }

  Future<Unit> unApproveHrdDenganSurat({
    required String nama,
    required SakitList itemSakit,
  }) {
    return _remoteService.unApproveHrdDenganSurat(
        nama: nama, itemSakit: itemSakit);
  }

  Future<Unit> unApproveHrdTanpaSurat({
    required String nama,
    required SakitList itemSakit,
    required CreateSakit createSakit,
    required MstKaryawanCuti mstCuti,
  }) {
    return _remoteService.unApproveHrdTanpaSurat(
        nama: nama,
        itemSakit: itemSakit,
        createSakit: createSakit,
        mstCuti: mstCuti);
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
