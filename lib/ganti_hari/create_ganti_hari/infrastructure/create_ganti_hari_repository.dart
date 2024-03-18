import '../application/absen_ganti_hari.dart';
import 'create_ganti_hari_remote_service.dart';

class CreateGantiHariRepository {
  CreateGantiHariRepository(this._remoteService);

  final CreateGantiHariRemoteService _remoteService;

  // Future<Unit> updateCuti({
  //   required String jenisCuti,
  //   required String alasan,
  //   required String ket,
  //   required String tahunCuti,
  //   required String nama,
  //   required int idCuti,
  //   required int idUser,
  //   required int sisaCuti,
  //   required int jumlahHari,
  //   required int hitungLibur,
  //   required DateTime tglAwalInDateTime,
  //   required DateTime tglAkhirInDateTime,
  // }) async {
  //   return _remoteService.updateCuti(
  //       jenisCuti: jenisCuti,
  //       alasan: alasan,
  //       ket: ket,
  //       tahunCuti: tahunCuti,
  //       nama: nama,
  //       idCuti: idCuti,
  //       idUser: idUser,
  //       sisaCuti: sisaCuti,
  //       jumlahHari: jumlahHari,
  //       hitungLibur: hitungLibur,
  //       tglAwalInDateTime: tglAwalInDateTime,
  //       tglAkhirInDateTime: tglAkhirInDateTime);
  // }

  // Future<Unit> submitCuti({
  //   required String jenisCuti,
  //   required String alasan,
  //   required String ket,
  //   required String tahunCuti,
  //   required int idUser,
  //   required int sisaCuti,
  //   required int jumlahHari,
  //   required int hitungLibur,
  //   required DateTime tglAwalInDateTime,
  //   required DateTime tglAkhirInDateTime,
  // }) async {
  //   return _remoteService.submitCuti(
  //       jenisCuti: jenisCuti,
  //       alasan: alasan,
  //       ket: ket,
  //       tahunCuti: tahunCuti,
  //       idUser: idUser,
  //       sisaCuti: sisaCuti,
  //       jumlahHari: jumlahHari,
  //       hitungLibur: hitungLibur,
  //       tglAwalInDateTime: tglAwalInDateTime,
  //       tglAkhirInDateTime: tglAkhirInDateTime);
  // }

  Future<List<AbsenGantiHari>> getAbsenGantiHari() async {
    return _remoteService.getAbsenGantiHari();
  }
}
