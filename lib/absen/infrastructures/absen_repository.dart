import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../background/application/saved_location.dart';
import '../../domain/absen_failure.dart';
import '../../domain/riwayat_absen_failure.dart';
import '../../infrastructures/exceptions.dart';
import '../../riwayat_absen/application/riwayat_absen_model.dart';

import '../../utils/string_utils.dart';

import '../application/absen_state.dart';
import 'absen_remote_service.dart';

class AbsenRepository {
  AbsenRepository(
    this._remoteService,
  );

  final AbsenRemoteService _remoteService;

  static const String dbNameProd = 'hr_trs_absen';

  Future<Either<AbsenFailure, Unit>> absen({
    required int idUser,
    required String nama,
    required String imei,
    required List<SavedLocation> absenList,
  }) async {
    try {
      if (absenList.isEmpty) {
        debugger();
      }

      Map<String, dynamic> query = {};
      for (int i = 0; i < absenList.length; i++) {
        final item = absenList[i];

        final isIn = item.absenState == AbsenState.empty();
        final ket = isIn ? 'MASUK' : 'PULANG';
        final coancenate = isIn ? 'masuk' : 'keluar';

        final trimmedDate = StringUtils.trimmedDate(item.date);
        final trimmedDateDb = StringUtils.trimmedDate(item.dbDate);

        query.addAll({
          '${item.id}': " INSERT INTO $dbNameProd " +
              "(tgljam, mode, id_user, imei, id_geof, c_date, c_user, latitude_$coancenate, longitude_$coancenate, lokasi_$coancenate)" +
              " VALUES " +
              " ('$trimmedDate', '$ket', '${idUser}', "
                  " '$imei', '${item.idGeof}', '$trimmedDateDb', '${nama}', "
                  " '${item.latitude}', '${item.longitude}', '${item.alamat}') ",
        });
      }

      if (query.isEmpty) {
        debugger();
      }

      debugger();

      await _remoteService.absen(
        absenMap: query,
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

  Future<Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>>> getRiwayatAbsen({
    required String? dateFirst,
    required String? dateSecond,
  }) async {
    try {
      final resp = await _remoteService.getRiwayatAbsen(
        dateFirst: dateFirst,
        dateSecond: dateSecond,
      );

      return right(resp);
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
