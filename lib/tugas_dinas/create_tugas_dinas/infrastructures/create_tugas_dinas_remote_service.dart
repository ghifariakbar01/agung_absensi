import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../constants/constants.dart';
import '../../../infrastructures/exceptions.dart';
import '../application/jenis_tugas_dinas.dart';
import '../application/user_list.dart';

class CreateTugasDinasRemoteService {
  CreateTugasDinasRemoteService(
    this._dio,
    this._dioHosting,
    this._dioRequest,
  );

  final Dio _dio;
  final Dio _dioHosting;
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
    required String username,
    required String pass,
    required bool jenis,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_dinas.asmx/insertDinas',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_user': idUser,
            'server': server,
            'tgl_start': tglAwal,
            'tgl_end': tglAkhir,
            'jam_start': jamAwal,
            'jam_end': jamAkhir,
            'ket': ket,
            'kategori': kategori,
            'perusahaan': perusahaan,
            'lokasi': lokasi,
            'id_pemberi': idPemberi,
            'jenis': jenis ? 1 : 0,
          }));

      log('username : ' + username);
      log('pass : ' + pass);
      log('id_user : ' + idUser.toString());
      log('server : ' + server!);
      log('tgl_start : ' + tglAwal);
      log('tgl_end : ' + tglAkhir);
      log('jam_start : ' + jamAwal);
      log('jam_end : ' + jamAkhir);
      log('ket : ' + ket);
      log('perusahaan : ' + perusahaan);
      log('lokasi : ' + lokasi);
      log('id_pemberi : ' + idPemberi.toString());
      log('jenis : ${jenis == true ? '1' : '0'}');

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
      } else {
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioException catch (e) {
      if ((e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout)) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<Unit> updateTugasDinas({
    required int idDinas,
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
    required String username,
    required String pass,
    required bool jenis,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final _headers = {
        'id_dinas': idDinas,
        'username': username,
        'pass': pass,
        'id_user': idUser,
        'server': server,
        'tgl_start': tglAwal,
        'tgl_end': tglAkhir,
        'jam_start': jamAwal,
        'jam_end': jamAkhir,
        'ket': ket,
        'kategori': kategori,
        'perusahaan': perusahaan,
        'lokasi': lokasi,
        'id_pemberi': idPemberi,
        'jenis': jenis ? 1 : 0,
      };

      final response = await _dio.post('/service_dinas.asmx/updateDinas',
          options: Options(
            contentType: 'text/plain',
            headers: _headers,
          ));

      log('_headers $_headers');

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
      } else {
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioException catch (e) {
      if ((e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout)) {
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
      final response = await _dio.post('/service_master.asmx/getJenisDinas',
          options: Options(contentType: 'text/plain', headers: {
            'server': Constants.isDev ? 'testing' : 'live',
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        final list = items['data'] as List;

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
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioException catch (e) {
      if ((e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout)) {
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

      final response = await _dioHosting.post(
        '',
        data: jsonEncode(data),
        options: Options(contentType: 'text/plain'),
      );

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
    } on DioException catch (e) {
      if ((e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout)) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<Unit> deleteTugasDinas({
    required int idDinas,
    required String username,
    required String pass,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_dinas.asmx/deleteDinas',
          options: Options(contentType: 'text/plain', headers: {
            'id_dinas': idDinas,
            'username': username,
            'pass': pass,
            'server': server,
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
      } else {
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioException catch (e) {
      if ((e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout)) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
