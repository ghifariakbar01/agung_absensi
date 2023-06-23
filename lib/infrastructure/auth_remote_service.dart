import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:face_net_authentication/infrastructure/dio_extensions.dart';
import 'package:face_net_authentication/infrastructure/dio_request.dart';

import '../application/user/user_model.dart';
import 'auth_response.dart';
import 'exceptions.dart';

class AuthRemoteService {
  AuthRemoteService(this._dio);

  final Dio _dio;

  Future<void> signOut() async {
    try {
      await _dio.get<dynamic>('logout');
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

  Future<AuthResponse> signIn({
    required String email,
    required String userId,
    required String password,
  }) async {
    try {
      final data = dioRequest;

      data.addAll({
        "username": "$userId",
        "password": "$password",
        "mode": "SELECT",
        "command":
            "SELECT * FROM mst_user WHERE email2 = '$email' OR email = '$email'",
      });

      log('data ${jsonEncode(data)}');

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final userExist = items['items'] != null && items['items'] is List;

        if (userExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            try {
              final listSelected = list[0];

              final UserModel user = UserModel(
                  idUser: listSelected['id_user'] ?? '',
                  nama: listSelected['nama'] ?? '',
                  fullname: listSelected['fullname'] ?? '',
                  password: password);

              return AuthResponse.withUser(user);
            } catch (_) {
              return AuthResponse.failure(
                errorCode: 00,
                message: 'Error parsing',
              );
            }
          } else {
            return AuthResponse.failure(
              errorCode: 00,
              message: 'User not found',
            );
          }
        } else {
          return AuthResponse.failure(
            errorCode: items['errornum'] as int?,
            message: items['error'] as String?,
          );
        }
      } else {
        final message = items['error'] as String?;
        return AuthResponse.failure(
          errorCode: items['errornum'],
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
