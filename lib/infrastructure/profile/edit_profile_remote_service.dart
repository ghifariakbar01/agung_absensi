import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/application/imei/imei_register_state.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../application/user/user_model.dart';
import '../exceptions.dart';

class EditProfileRemoteService {
  EditProfileRemoteService(
      this._dio, this._userModelWithPassword, this._dioRequest);

  final Dio _dio;
  final UserModelWithPassword _userModelWithPassword;
  final Map<String, String> _dioRequest;

  static const String dbName = 'mst_user';

  Future<String?> getImei() async {
    try {
      final data = _dioRequest;

      final commandUpdate =
          "SELECT imei_hp FROM $dbName WHERE idKary = '${_userModelWithPassword.idKary}'";

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
          return items['items'][0]['imei_hp'];
        } else {
          return '';
        }
      } else {
        throw RestApiException(10);
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

  Future<Unit> clearImei() async {
    try {
      final data = _dioRequest;

      final commandUpdate =
          "UPDATE $dbName SET imei_hp = '' WHERE idKary = '${_userModelWithPassword.idKary}'";

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
        throw RestApiException(10);
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

  Future<ImeiRegisterResponse> registerImei({required String imei}) async {
    try {
      final data = _dioRequest;

      final commandUpdate =
          "UPDATE $dbName SET imei_hp = '$imei' WHERE idKary = '${_userModelWithPassword.idKary}'";

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

  Future<Unit> submitEdit({
    required String noTelp1,
    required String noTelp2,
    required String email1,
    required String email2,
  }) async {
    try {
      final data = _dioRequest;

      final commandUpdate =
          "UPDATE $dbName SET no_telp1 = '$noTelp1', no_telp2 = '$noTelp2', email = '$email1', email2 = '$email2' WHERE idKary = '${_userModelWithPassword.idKary}'";

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
        throw RestApiException(10);
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
