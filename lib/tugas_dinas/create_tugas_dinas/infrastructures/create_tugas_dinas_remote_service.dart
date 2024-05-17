import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';

import '../../../infrastructures/exceptions.dart';
import '../application/jenis_tugas_dinas.dart';
import '../application/user_list.dart';

class CreateTugasDinasRemoteService {
  CreateTugasDinasRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_dinas';
  static const String dbMstUser = 'mst_user';
  static const String dbHrMstJenisTugasDinas = 'hr_mst_dinas';

  Future<Unit> submitTugasDinas({
    required int idUser,
    required int idPemberi,
    required String ket,
    required String tglAwal,
    required String tglAkhir,
    required String jamAwal,
    required String jamAkhir,
    required String kategori,
    required String perusahaan,
    required String lokasi,
    required String cUser,
    required bool khusus,
  }) async {
    try {
      final Map<String, String> submitTugasDinas = {
        "command": "INSERT INTO $dbName ("
            "id_user, ket, tgl_start, tgl_end, jam_start, jam_end, "
            "kategori, perusahaan, lokasi, id_comp, id_dept, id_pemberi, "
            "spv_sta, spv_nm, spv_tgl, hrd_sta, hrd_nm, hrd_tgl, "
            "coo_sta, coo_nm, coo_tgl, gm_sta, gm_nm, gm_tgl, jenis, "
            "c_date, c_user, u_date, u_user) VALUES ("
            "$idUser, "
            "'$ket', "
            "'$tglAwal', "
            "'$tglAkhir', "
            "'$jamAwal', "
            "'$jamAkhir', "
            "'$kategori', "
            "'$perusahaan', "
            "'$lokasi', "
            "(SELECT id_comp FROM $dbMstUser WHERE id_user = $idUser), "
            "(SELECT id_dept FROM $dbMstUser WHERE id_user = $idUser), "
            "$idPemberi, "
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
            "${khusus ? "'1'" : "'0'"}, "
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

  Future<Unit> updateTugasDinas({
    required int id,
    required int idUser,
    required int idPemberi,
    required String ket,
    required String tglAwal,
    required String tglAkhir,
    required String jamAwal,
    required String jamAkhir,
    required String kategori,
    required String perusahaan,
    required String lokasi,
    required bool khusus,
    required String uUser,
  }) async {
    try {
      // add spv / hrd note
      final Map<String, String> submitTugasDinas = {
        "command": " UPDATE $dbName SET "
            "  id_user = $idUser, "
            "  id_pemberi = $idPemberi, "
            "  ket = '$ket', "
            "  tgl_start = '$tglAwal', "
            "  tgl_end = '$tglAkhir', "
            "  jam_start = '$jamAwal', "
            "  jam_end = '$jamAkhir', "
            "  kategori = '$kategori', "
            "  perusahaan = '$perusahaan', "
            "  lokasi = '$lokasi', "
            "  id_comp = (SELECT id_comp FROM $dbMstUser WHERE id_user = $idUser), "
            "  id_dept = (SELECT id_dept FROM $dbMstUser WHERE id_user = $idUser), "
            "  u_date = GETDATE(), "
            "  jenis = ${khusus ? '1' : '0'}, "
            "  u_user = '$uUser' "
            "  WHERE id_dinas = $id ",
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

  Future<List<JenisTugasDinas>> getJenisTugasDinas() async {
    try {
      final Map<String, String> submitTugasDinas = {
        "command": "SELECT * FROM $dbHrMstJenisTugasDinas ",
        "mode": "SELECT"
      };

      final data = _dioRequest;
      data.addAll(submitTugasDinas);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final list = items['items'] as List;

        if (list.isNotEmpty) {
          return list
              .map((e) => JenisTugasDinas.fromJson(e as Map<String, dynamic>))
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

  Future<List<UserList>> getPemberiTugasListNamed(String name) async {
    try {
      final Map<String, String> submitTugasDinas = {
        "command": "SELECT * "
            "  FROM "
            "      $dbMstUser "
            "  ${name.isEmpty ? " WHERE aktip = 1 " : " WHERE fullname LIKE '%$name%' AND aktip = 1 OR nama LIKE '%$name%' AND aktip = 1 "}  "
            "  ORDER BY "
            "      c_date ASC "
            "  OFFSET "
            "      0 ROWS FETCH FIRST 20 ROWS ONLY ",
        "mode": "SELECT"
      };

      final data = _dioRequest;
      data.addAll(submitTugasDinas);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final list = items['items'] as List;

        if (list.isNotEmpty) {
          return list
              .map((e) => UserList.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          return [];
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
