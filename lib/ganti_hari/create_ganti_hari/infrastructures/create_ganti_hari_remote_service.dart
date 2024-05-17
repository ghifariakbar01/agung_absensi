import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';

import '../../../infrastructures/exceptions.dart';
import '../application/absen_ganti_hari.dart';

class CreateGantiHariRemoteService {
  CreateGantiHariRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_dayoff';
  static const String dbMstUser = 'mst_user';
  static const String dbHrMstJenisAbsen = 'mst_absen';

  Future<Unit> submitGantiHari({
    required int idUser,
    required int idAbsen,
    required String ket,
    required String tglOff,
    required String tglGanti,
    required String cUser,
  }) async {
    try {
      final Map<String, String> submitTugasDinas = {
        "command": "INSERT INTO $dbName ("
            "id_user, ket, tgl_start, tgl_end, id_comp, id_dept, id_absen, "
            "spv_sta, spv_nm, spv_tgl, hrd_sta, hrd_nm, hrd_tgl, "
            "coo_sta, coo_nm, coo_tgl, gm_sta, gm_nm, gm_tgl, "
            "c_date, c_user, u_date, u_user) VALUES ("
            "$idUser, "
            "'$ket', "
            "'$tglOff', "
            "'$tglGanti', "
            "(SELECT id_comp FROM $dbMstUser WHERE id_user = $idUser), "
            "(SELECT id_dept FROM $dbMstUser WHERE id_user = $idUser), "
            "$idAbsen, "
            "'0', "
            "'', "
            "GETDATE(), "
            "'0', "
            "'', "
            "GETDATE(), "
            "'0', "
            "'', "
            "GETDATE(), "
            "'0', "
            "'', "
            "GETDATE(), "
            "GETDATE(), "
            "'$cUser', "
            "GETDATE(), "
            "'$cUser') ",
        "mode": "INSERT"
      };

      final data = _dioRequest;
      data.addAll(submitTugasDinas);
      log('query $submitTugasDinas');
      // debugger();

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

  Future<Unit> updateGantiHari({
    required int id,
    required int idAbsen,
    required String ket,
    required String tglOff,
    required String tglGanti,
    required String uUser,
  }) async {
    try {
      // add spv / hrd note
      final Map<String, String> submitTugasDinas = {
        "command": " UPDATE $dbName SET "
            "  ket = '$ket', "
            "  tgl_start = '$tglOff', "
            "  tgl_end = '$tglGanti', "
            "  u_date = GETDATE(), "
            "  u_user = '$uUser' "
            "  WHERE id_dayoff = $id ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(submitTugasDinas);

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

  Future<List<AbsenGantiHari>> getAbsenGantiHari() async {
    try {
      final Map<String, String> getAbsenGantiHari = {
        "command": "SELECT * FROM $dbHrMstJenisAbsen order by nama asc",
        "mode": "SELECT"
      };

      final data = _dioRequest;
      data.addAll(getAbsenGantiHari);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final list = items['items'] as List;

        if (list.isNotEmpty) {
          return list
              .map((e) => AbsenGantiHari.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          final message = 'List absen ganti hari empty';
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
