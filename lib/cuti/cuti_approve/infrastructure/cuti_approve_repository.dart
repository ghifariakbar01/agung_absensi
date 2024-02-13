import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/mst_karyawan_cuti/application/mst_karyawan_cuti.dart';

import '../../cuti_list/application/cuti_list.dart';
import 'cuti_approve_remote_service.dart.dart';

class CutiApproveRepository {
  CutiApproveRepository(this._remoteService);

  final CutiApproveRemoteService _remoteService;

  Future<Unit> approveSpv(
      {required int idCuti, required String nama, required String note}) async {
    return _remoteService.approveSpv(idCuti: idCuti, nama: nama, note: note);
  }

  Future<Unit> unapproveSpv({
    required int idCuti,
    required String nama,
  }) {
    return _remoteService.unapproveSpv(
      idCuti: idCuti,
      nama: nama,
    );
  }

  Future<Unit> approveHrd({
    required String nama,
    required String note,
    required CutiList itemCuti,
    // required CreateSakit createSakit,
  }) async {
    return _remoteService.approveHrd(
      nama: nama,
      note: note,
      itemCuti: itemCuti,
    );
  }

  Future<Unit> unapproveHrd({
    required String nama,
    required CutiList itemCuti,
    // required CreateSakit createSakit,
  }) {
    return _remoteService.unapproveHrd(
      nama: nama,
      itemCuti: itemCuti,
    );
  }

  Future<Unit> calcSisaCuti(
      {required CutiList itemCuti, bool isRestore = false}) {
    return _remoteService.calcSisaCuti(
        itemCuti: itemCuti, isRestore: isRestore);
  }

  Future<Unit> calcCutiTidakBaru({
    required int totalHari,
    required MstKaryawanCuti mstCuti,
    bool isRestore = false,
  }) {
    return _remoteService.calcCutiTidakBaru(
      totalHari: totalHari,
      mstCuti: mstCuti,
      isRestore: isRestore,
    );
  }

  Future<Unit> calcCutiBaru({
    required int totalHari,
    required MstKaryawanCuti mstCuti,
    bool isRestore = false,
  }) {
    return _remoteService.calcCutiBaru(
      totalHari: totalHari,
      isRestore: isRestore,
      mstCuti: mstCuti,
    );
  }

  Future<Unit> calcCloseOpenDate({
    required String masuk,
    required MstKaryawanCuti mstCuti,
  }) {
    return _remoteService.calcCloseOpenDate(
      masuk: masuk,
      mstCuti: mstCuti,
    );
  }

  Future<Unit> calcCloseOpenCutiTidakBaruDanTahuCuti({
    required String masuk,
    required MstKaryawanCuti mstCuti,
  }) {
    return _remoteService.calcCloseOpenCutiTidakBaruDanTahuCuti(
      masuk: masuk,
      mstCuti: mstCuti,
    );
  }

  Future<Unit> calcCloseOpenCutiTidakBaruDanTahuCuti2({
    required MstKaryawanCuti mstCuti,
  }) {
    return _remoteService.calcCloseOpenCutiTidakBaruDanTahuCuti2(
      mstCuti: mstCuti,
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
