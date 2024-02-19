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
  static const String dbName = 'hr_trs_izin';

  Future<Unit> submitIzin({
    required int idUser,
    required int idMstIzin,
    required int totalHari,
    required String ket,
    required String cUser,
    required String tglEnd,
    required String tglStart,
    // required int jumlahHari,
    // required int hitungLibur,
  }) async {
    try {
      final Map<String, String> submitSakit = {
        "command": "INSERT INTO $dbName ("
            "id_user, ket, tgl_start, tgl_end, tgl_start_hrd, tgl_end_hrd, "
            "hrd_note, spv_note, tot_hari, id_mst_izin, "
            "spv_sta, spv_nm, spv_tgl, hrd_sta, hrd_nm, hrd_tgl, "
            "c_date, c_user, u_date, u_user) VALUES ("
            "$idUser, "
            "'$ket', "
            "'$tglStart', "
            "'$tglEnd', "
            "'$tglStart', "
            "'$tglEnd', "
            "'', "
            "'', "
            // "((datediff(day,'$tglStart', '$tglEnd') + 1) - $jumlahHari) - $hitungLibur, "
            "$totalHari, "
            "$idMstIzin, "
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

  Future<Unit> updateIzin({
    required int id,
    required int idUser,
    required int idMstIzin,
    required int totalHari,
    required String ket,
    required String uUser,
    required String tglEnd,
    required String tglStart,
    // required int jumlahHari,
    // required int hitungLibur,
  }) async {
    try {
      // add spv / hrd note
      final Map<String, String> submitSakit = {
        "command": "UPDATE $dbName SET "
            " id_user = $idUser,  "
            " ket = '$ket',  "
            " tgl_start = '$tglStart',  "
            " tgl_end = '$tglEnd',  "
            " tgl_start_hrd = '$tglStart',  "
            " tgl_end_hrd = '$tglEnd',  "
            " spv_note = '',  "
            " hrd_note = '',  "
            " id_mst_izin = $idMstIzin,  "
            " tot_hari = $totalHari,  "
            " u_date = getdate(), "
            " u_user = '$uUser' "
            " WHERE id_izin = $id ",
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
