import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../../infrastructure/exceptions.dart';
import '../application/jenis_absen.dart';

class CreateAbsenManualRemoteService {
  CreateAbsenManualRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_absenmnl';
  static const String dbHrMstJenisAbsen = 'Master_Jenis_Absen';

  Future<Unit> submitAbsenManual({
    required int idUser,
    required String ket,
    required String tgl,
    required String jamAwal,
    required String jamAkhir,
    required String jenisAbsen,
    required String cUser,
  }) async {
    try {
      final Map<String, String> submitSakit = {
        "command": "INSERT INTO $dbName ("
            "id_absenmnl, id_user, ket, tgl, jam_awal, jam_akhir, jenis_absen, periode, "
            "spv_sta, spv_nm, spv_tgl, hrd_sta, hrd_nm, hrd_tgl, hrd_note, spv_note, "
            "c_date, c_user, u_date, u_user) VALUES ("
            "(select isnull(max(id_absenmnl),0) + 1 from $dbName), "
            "$idUser, "
            "'$ket', "
            "'$tgl', "
            "'$jamAwal', "
            "'$jamAkhir', "
            "'$jenisAbsen', "
            "(DATENAME (MONTH,'$tgl')), "
            "'0', "
            "'', "
            "GETDATE(), "
            "'0', "
            "'', "
            "GETDATE(), "
            "'', "
            "'', "
            "GETDATE(), "
            "'$cUser', "
            "GETDATE(), "
            "'$cUser') ",
        "mode": "INSERT"
      };

      final data = _dioRequest;
      data.addAll(submitSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data $jsonEncode(data)');
      log('response $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        return unit;
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioError catch (e) {
      if (e.isNoConnectionError || e.isConnectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<Unit> updateAbsenManual({
    required int id,
    required int idUser,
    required String ket,
    required String tgl,
    required String jamAwal,
    required String jamAkhir,
    required String jenisAbsen,
    required String uUser,
  }) async {
    try {
      // add spv / hrd note
      final Map<String, String> submitSakit = {
        "command": "UPDATE $dbName SET "
            " id_user = $idUser,  "
            " ket = '$ket',  "
            " tgl = '$tgl',  "
            " jam_awal = '$jamAwal',  "
            " jam_akhir = '$jamAkhir',  "
            " jenis_absen = '$jenisAbsen',  "
            " periode = (DATENAME (MONTH,'$tgl')),  "
            " spv_note = '',  "
            " hrd_note = '',  "
            " u_date = getdate(), "
            " u_user = '$uUser' "
            " WHERE id_absenmnl = $id ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(submitSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      final items = response.data?[0];

      if (items['status'] == 'Success') {
        return unit;
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioError catch (e) {
      if (e.isNoConnectionError || e.isConnectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<List<JenisAbsen>> getJenisAbsen() async {
    try {
      final Map<String, String> submitSakit = {
        "command": "SELECT * FROM $dbHrMstJenisAbsen ",
        "mode": "SELECT"
      };

      final data = _dioRequest;
      data.addAll(submitSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final list = items['items'] as List;

        if (list.isNotEmpty) {
          return list
              .map((e) => JenisAbsen.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          final message = 'List jenis cuti empty';
          final errorCode = 404;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioError catch (e) {
      if (e.isNoConnectionError || e.isConnectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
