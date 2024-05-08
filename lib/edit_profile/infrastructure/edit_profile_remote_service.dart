import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../imei/application/imei_register_state.dart';
import '../../infrastructure/exceptions.dart';
import '../../utils/string_utils.dart';

class EditProfileRemoteService {
  EditProfileRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'mst_user';
  static const String dbLogName = 'log_unlink_mobile';

  Future<String?> getImei({required String idKary}) async {
    try {
      /*
        FOR TESTING,
          use gs_12 on login, absen, riwayat
      */
      final Map<String, dynamic> data = {};
      data.addAll(_dioRequest);

      final commandUpdate =
          "SELECT imei_hp FROM $dbName WHERE idKary = '$idKary'";

      final Map<String, String> select = {
        'command': commandUpdate,
        'mode': 'SELECT'
      };

      data.addAll(select);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');

      log('response $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        if (items['items'][0]['imei_hp'] != null) {
          String imei = items['items'][0]['imei_hp'];
          //
          if (imei.isNotEmpty) {
            return imei;
          } else {
            return null;
          }
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

  Future<Unit> clearImei({required String idKary}) async {
    try {
      /*
        FOR TESTING,
          use gs_12 on login, absen, riwayat
      */
      final Map<String, dynamic> data = {};
      data.addAll(_dioRequest);

      final commandUpdate =
          "UPDATE $dbName SET imei_hp = '' WHERE idKary = '$idKary'";

      final Map<String, String> edit = {
        'command': commandUpdate,
        'mode': 'UPDATE'
      };

      data.addAll(edit);

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
    } on FormatException {
      throw FormatException();
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

  Future<Unit> logClearImei({
    required String imei,
    required String nama,
    required String idUser,
  }) async {
    try {
      /*
        FOR TESTING,
          use gs_12 on login, absen, riwayat
      */
      final Map<String, dynamic> data = {};
      data.addAll(_dioRequest);

      final dateNow = DateTime.now();

      final commandInsert = "INSERT INTO $dbLogName " +
          " (id_user, tgl, imei_lama, unlink_by, tipe) " +
          " VALUES " +
          " ( " +
          " $idUser, " +
          " '${StringUtils.trimmedDate(dateNow)}', " +
          " '$imei', "
              " '$nama', " +
          " 'Mobile' "
              " ) ";

      final Map<String, String> edit = {
        'command': commandInsert,
        'mode': 'INSERT'
      };

      data.addAll(edit);

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
    } on FormatException {
      throw FormatException();
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

  Future<ImeiRegisterResponse> registerImei(
      {required String imei, required String idKary}) async {
    try {
      /*
        FOR TESTING,
          use gs_12 on login, absen, riwayat
      */
      final Map<String, dynamic> data = {};
      data.addAll(_dioRequest);

      final commandUpdate =
          "UPDATE $dbName SET imei_hp = '$imei' WHERE idKary = '$idKary'";

      final Map<String, String> edit = {
        'command': commandUpdate,
        'mode': 'UPDATE'
      };

      data.addAll(edit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');

      log('response $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        return ImeiRegisterResponse.withImei(imei: imei);
      } else {
        return ImeiRegisterResponse.failure(
          items['errornum'] as int?,
          items['error'] as String?,
        );
      }
    } on FormatException {
      throw FormatException();
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

  Future<Unit> submitEdit(
      {required String noTelp1,
      required String noTelp2,
      required String email1,
      required String email2,
      required String idKary}) async {
    try {
      /*
        FOR TESTING,
          use gs_12 on login, absen, riwayat
      */
      final Map<String, dynamic> data = {};
      data.addAll(_dioRequest);
      final _testing = data.update('server', (_) => 'gs_12');

      if (_testing != 'gs_12') {
        throw Exception('server override invalid');
      }

      final commandUpdate =
          "UPDATE $dbName SET no_telp1 = '$noTelp1', no_telp2 = '$noTelp2', email = '$email1', email2 = '$email2' WHERE idKary = '$idKary'";

      final Map<String, String> edit = {
        'command': commandUpdate,
        'mode': 'UPDATE'
      };

      debugger();

      data.addAll(edit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');

      log('response $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        debugger();

        return unit;
      } else {
        debugger();

        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException {
      throw FormatException();
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
