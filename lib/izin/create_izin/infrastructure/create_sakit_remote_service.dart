import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../../infrastructure/exceptions.dart';

class CreateIzinRemoteService {
  CreateIzinRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbKaryawan = 'karyawan';
  static const String dbMstLibur = 'mst_libur';
  static const String dbHrSakit = 'hr_trs_sakit';
  static const String dbMstCutiNew = 'hr_mst_cuti_new';

  Future<Unit> submitIzin({
    required int idUser,
    required String ket,
    required String surat,
    required String cUser,
    required String tglEnd,
    required String tglStart,
    required int jumlahHari,
    required int hitungLibur,
  }) async {
    try {
      final Map<String, String> submitSakit = {
        "command": "INSERT INTO $dbHrSakit ("
            "id_user, ket, tgl_start, tgl_end, surat, tot_hari, periode, "
            "spv_sta, spv_nm, spv_tgl, hrd_sta, hrd_nm, hrd_tgl, "
            "c_date, c_user, u_date, u_user) VALUES ("
            "$idUser, "
            "'$ket', "
            "'$tglStart', "
            "'$tglEnd', "
            "'$surat', "
            "((datediff(day,'$tglStart', '$tglEnd') + 1) - $jumlahHari) - $hitungLibur, "
            "(DATENAME(MONTH,'$tglStart')), "
            "'0', "
            "'', "
            "getdate(), "
            "'0', "
            "'', "
            "getdate(), "
            "getdate(), "
            "'$cUser', "
            "getdate(), "
            "'$cUser') ",
        "mode": "INSERT"
      };

      final data = _dioRequest;
      data.addAll(submitSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      debugger();
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

  Future<int> getLastSubmitSakit({
    required int idUser,
  }) async {
    try {
      final Map<String, String> submitSakit = {
        "command": " SELECT TOP 1 * FROM "
            " $dbHrSakit WHERE id_user = $idUser ORDER BY c_date DESC ",
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
        final listExist = items['items'] != null && items['items'] is List;

        if (listExist) {
          if (items['items'][0]['id_sakit'] != null) {
            final idSakit = items['items'][0]['id_sakit'] as int;
            return idSakit;
          }

          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

          throw RestApiExceptionWithMessage(errorCode, message);
        } else {
          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

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

  Future<Unit> updateSakit({
    required int id,
    required int idUser,
    required String ket,
    required String surat,
    required String uUser,
    required String tglEnd,
    required String tglStart,
    required int jumlahHari,
    required int hitungLibur,
  }) async {
    try {
      // add spv / hrd note
      final Map<String, String> submitSakit = {
        "command": "UPDATE $dbHrSakit SET "
            " id_user = $idUser,  "
            " ket = '$ket',  "
            " surat = '$surat',  "
            " tot_hari = ((datediff(day,'$tglStart', '$tglEnd') + 1) - $jumlahHari) - $hitungLibur,  "
            " periode = (DATENAME(MONTH,'$tglStart')),  "
            " tgl_start = '$tglStart',  "
            " tgl_end = '$tglEnd',  "
            " spv_note = '',  "
            " hrd_note = '',  "
            " u_date = getdate(), "
            " u_user = '$uUser' "
            " WHERE id_sakit = $id ",
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
}
