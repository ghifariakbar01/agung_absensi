import 'package:dartz/dartz.dart';

import '../../application/absen/absen_enum.dart';
import '../../application/absen/absen_state.dart';
import '../../application/riwayat_absen/riwayat_absen_model.dart';
import '../../domain/absen_failure.dart';
import '../../domain/riwayat_absen_failure.dart';
import '../exceptions.dart';
import 'absen_remote_service.dart';

class AbsenRepository {
  AbsenRepository(
    this._remoteService,
  );

  final AbsenRemoteService _remoteService;

  Future<Either<AbsenFailure, Unit>> absen({
    required String imei,
    required DateTime date,
    required String idGeof,
    required String lokasi,
    required DateTime dbDate,
    required String latitude,
    required String longitude,
    required JenisAbsen inOrOut,
  }) async {
//
// FOR TESTING PURPOSES
// id geof 4
// -6.277117, 107.066174
// 7c7707f6-43d0-4d4d-bc44-625a54806853
// P3F8+2CX, Jl. Kelana, Cibuntu, Kec. Cibitung, Kabupaten Bekasi, Jawa Barat 17510

    try {
      await _remoteService.absen(
        imei: imei,
        date: date,
        idGeof: idGeof,
        dbDate: dbDate,
        lokasi: lokasi,
        inOrOut: inOrOut,
        latitude: latitude,
        longitude: longitude,
      );

      return right(unit);
    } on NoConnectionException {
      return left(AbsenFailure.noConnection());
    } on RestApiException catch (error) {
      return left(AbsenFailure.server(error.errorCode));
    } on RestApiExceptionWithMessage catch (error) {
      return left(AbsenFailure.server(error.errorCode, error.message));
    }
  }

  Future<AbsenState> getAbsen({required DateTime date}) async {
    try {
      return await _remoteService.getAbsen(date: date);
    } on NoConnectionException {
      return AbsenState.failure(message: 'no connection');
    } on RestApiExceptionWithMessage catch (e) {
      return AbsenState.failure(errorCode: e.errorCode, message: e.message);
    } on RestApiException catch (e) {
      return AbsenState.failure(
          errorCode: e.errorCode, message: 'RestApiException getAbsen');
    }
  }

  Future<Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>>> getRiwayatAbsen(
      {required int page,
      required String? dateFirst,
      required String? dateSecond}) async {
    try {
      return right(await _remoteService.getRiwayatAbsen(
          page: page, dateFirst: dateFirst, dateSecond: dateSecond));
    } on NoConnectionException {
      return left(RiwayatAbsenFailure.noConnection());
    } on FormatException catch (e) {
      return left(RiwayatAbsenFailure.wrongFormat(e.message));
    } on RestApiException catch (e) {
      return left(RiwayatAbsenFailure.server(e.errorCode));
    } on RestApiExceptionWithMessage catch (e) {
      return left(RiwayatAbsenFailure.server(e.errorCode, e.message));
    }
  }
}
