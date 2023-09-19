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
    required String idGeof,
    required String lokasi,
    required String latitude,
    required String longitude,
    required String imei,
    required DateTime date,
    required DateTime dbDate,
    required JenisAbsen inOrOut,
  }) async {
    try {
      await _remoteService.absen(
          date: date,
          dbDate: dbDate,
          lokasi: lokasi,
          latitude: latitude,
          longitude: longitude,
          inOrOut: inOrOut,
          idGeof: idGeof,
          imei: imei);

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
