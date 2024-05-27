import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';

import '../../infrastructures/exceptions.dart';
import '../../user/application/user_model.dart';
import '../application/network_response.dart';

class NetworkStateRemoteService {
  NetworkStateRemoteService(
      this._dio, this._dioRequestNotifier, this._userModelWithPassword);

  final Dio _dio;
  final Map<String, String> _dioRequestNotifier;
  final UserModelWithPassword _userModelWithPassword;

  Future<NetworkResponse> ping() async {
    try {
      final data = _dioRequestNotifier;

      data.addAll({
        "username": "${_userModelWithPassword.nama}",
        "password": "${_userModelWithPassword.password}",
        "mode": "SELECT",
        "command":
            "SELECT * FROM mst_user WHERE nama LIKE '%${_userModelWithPassword.nama}%'",
      });

      final response = await _dio.post(
        '',
        data: jsonEncode(data),
        options: Options(contentType: 'text/plain'),
      );

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final userExist = items['items'] != null && items['items'] is List;

        if (userExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            return NetworkResponse.withData();
          } else {
            return NetworkResponse.failure(
              errorCode: 00,
              message: 'List in mst_user is empty',
            );
          }
        } else {
          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

          return NetworkResponse.failure(
            errorCode: errorCode,
            message: message,
          );
        }
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        return NetworkResponse.failure(
          errorCode: errorCode,
          message: message,
        );
      }
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
