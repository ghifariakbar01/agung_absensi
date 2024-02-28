import 'package:dartz/dartz.dart';

import 'tugas_dinas_approve_remote_service.dart.dart';

class TugasDinasApproveRepository {
  TugasDinasApproveRepository(this._remoteService);

  final TugasDinasApproveRemoteService _remoteService;

  Future<Unit> approveSpv({required int idDinas, required String nama}) async {
    return _remoteService.approveSpv(
      idDinas: idDinas,
      nama: nama,
    );
  }

  Future<Unit> unApproveSpv(
      {required int idDinas, required String nama}) async {
    return _remoteService.unApproveSpv(
      idDinas: idDinas,
      nama: nama,
    );
  }

  Future<Unit> approveGm({required int idDinas, required String namaGm}) async {
    return _remoteService.approveGm(
      idDinas: idDinas,
      namaGm: namaGm,
    );
  }

  Future<Unit> unapproveGm(
      {required int idDinas, required String namaGm}) async {
    return _remoteService.unApproveGm(
      idDinas: idDinas,
      namaGm: namaGm,
    );
  }

  Future<Unit> approveCOO(
      {required int idDinas, required String namaCoo}) async {
    return _remoteService.approveCOO(
      idDinas: idDinas,
      namaCoo: namaCoo,
    );
  }

  Future<Unit> unApproveCOO(
      {required int idDinas, required String namaCoo}) async {
    return _remoteService.unApproveCOO(
      idDinas: idDinas,
      namaCoo: namaCoo,
    );
  }

  Future<Unit> approveHrdLK({
    required int idDinas,
    required String namaHrd,
  }) async {
    return _remoteService.approveHrdLK(namaHrd: namaHrd, idDinas: idDinas);
  }

  Future<Unit> unapproveHrdLK({
    required int idDinas,
    required String nama,
  }) async {
    return _remoteService.unApproveHrdLk(
      nama: nama,
      idDinas: idDinas,
    );
  }

  Future<Unit> approveHrd({
    required int idDinas,
    required String namaHrd,
  }) async {
    return _remoteService.approveHrd(namaHrd: namaHrd, idDinas: idDinas);
  }

  Future<Unit> unapproveHrd({
    required int idDinas,
    required String namaHrd,
  }) async {
    return _remoteService.unapproveHrd(namaHrd: namaHrd, idDinas: idDinas);
  }

  Future<Unit> batal({
    required int idDinas,
    required String nama,
  }) async {
    return _remoteService.batal(nama: nama, idDinas: idDinas);
  }
}
