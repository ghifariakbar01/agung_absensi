import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';

import '../../../infrastructures/exceptions.dart';

class CreateDtPcRemoteService {
  CreateDtPcRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_dt';

  Future<Unit> submitDtPc({
    required int idUser,
    required String ket,
    required String dtTgl,
    required String jam,
    required String kategori,
    required String cUser,
  }) async {
    try {
      final Map<String, String> submitSakit = {
        "command": "INSERT INTO $dbName ("
            "id_user, ket, dt_tgl, jam, periode, kategori, "
            "spv_sta, spv_nm, spv_tgl, hrd_sta, hrd_nm, hrd_tgl, hrd_note, spv_note,  "
            "c_date, c_user, u_date, u_user) VALUES ("
            "$idUser, "
            "'$ket', "
            "'$dtTgl', "
            "'$jam', "
            "(DATENAME (MONTH,'$dtTgl')), "
            "'$kategori', "
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

  Future<Unit> updateDtPc({
    required int id,
    required int idUser,
    required String ket,
    required String dtTgl,
    required String jam,
    required String kategori,
    required String uUser,
  }) async {
    try {
      // add spv / hrd note
      final Map<String, String> submitSakit = {
        "command": "UPDATE $dbName SET "
            " id_user = $idUser,  "
            " ket = '$ket',  "
            " dt_tgl = '$dtTgl',  "
            " jam = '$jam',  "
            " kategori = '$kategori',  "
            " periode = (DATENAME (MONTH,'$dtTgl')),  "
            " spv_note = '',  "
            " hrd_note = '',  "
            " u_date = getdate(), "
            " u_user = '$uUser' "
            " WHERE id_dt = $id ",
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
