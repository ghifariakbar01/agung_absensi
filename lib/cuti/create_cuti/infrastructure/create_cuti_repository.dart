// import 'dart:developer';

import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../application/alasan_cuti.dart';
import '../application/jenis_cuti.dart';
import 'create_cuti_remote_service.dart';

// import '../application/sakit_list.dart';

class CreateCutiRepository {
  CreateCutiRepository(this._remoteService);

  final CreateCutiRemoteService _remoteService;

  Future<Unit> updateCuti({
    required String jenisCuti,
    required String alasan,
    required String ket,
    required String tahunCuti,
    required String nama,
    required int idCuti,
    required int idUser,
    required int sisaCuti,
    required int jumlahHari,
    required int hitungLibur,
    required DateTime tglAwalInDateTime,
    required DateTime tglAkhirInDateTime,
  }) async {
    return _remoteService.updateCuti(
        jenisCuti: jenisCuti,
        alasan: alasan,
        ket: ket,
        tahunCuti: tahunCuti,
        nama: nama,
        idCuti: idCuti,
        idUser: idUser,
        sisaCuti: sisaCuti,
        jumlahHari: jumlahHari,
        hitungLibur: hitungLibur,
        tglAwalInDateTime: tglAwalInDateTime,
        tglAkhirInDateTime: tglAkhirInDateTime);
  }

  Future<Unit> submitCuti({
    required String jenisCuti,
    required String alasan,
    required String ket,
    required String tahunCuti,
    required int idUser,
    required int sisaCuti,
    required int jumlahHari,
    required int hitungLibur,
    required DateTime tglAwalInDateTime,
    required DateTime tglAkhirInDateTime,
  }) async {
    return _remoteService.submitCuti(
        jenisCuti: jenisCuti,
        alasan: alasan,
        ket: ket,
        tahunCuti: tahunCuti,
        idUser: idUser,
        sisaCuti: sisaCuti,
        jumlahHari: jumlahHari,
        hitungLibur: hitungLibur,
        tglAwalInDateTime: tglAwalInDateTime,
        tglAkhirInDateTime: tglAkhirInDateTime);
  }

  Future<List<AlasanCuti>> getAlasanEmergency() {
    return _remoteService.getAlasanEmergency();
  }

  Future<List<JenisCuti>> getJenisCuti() {
    return _remoteService.getJenisCuti();
  }

  Future<Unit> resetCutiTahunMasuk({
    required int idUser,
    required String nama,
    required String masuk,
  }) {
    return _remoteService.resetCutiTahunMasuk(
        idUser: idUser, nama: nama, masuk: masuk);
  }

  Future<Unit> resetCutiSatuTahunLebih({
    required int idUser,
    required String nama,
    required String masuk,
  }) {
    return _remoteService.resetCutiSatuTahunLebih(
        idUser: idUser, nama: nama, masuk: masuk);
  }

  Future<Unit> resetCutiDuaTahunLebih({
    required int idUser,
    required String nama,
    required String masuk,
  }) {
    return _remoteService.resetCutiDuaTahunLebih(
        idUser: idUser, nama: nama, masuk: masuk);
  }
}
