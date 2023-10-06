import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../application/user/user_model.dart';

import '../exceptions.dart';
import 'auth_response.dart';

class AuthRemoteService {
  AuthRemoteService(this._dio, this._dioRequestNotifier);

  final Dio _dio;
  final Map<String, String> _dioRequestNotifier;

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

  Future<AuthResponse> signIn(
      {required String userId,
      required String password,
      required String server}) async {
    try {
      final data = _dioRequestNotifier;

      data.addAll({
        "username": "$userId",
        "password": "$password",
        "mode": "SELECT",
        "command": "SELECT *, (select nama from mst_dept where id_dept = A.id_dept) as dept, " +
            " (select nama from mst_comp where id_comp = A.id_comp) as comp, (select nama from mst_jabatan where id_jbt = A.id_jbt) as jbt" +
            " FROM mst_user A WHERE nama = '$userId'  AND payroll IS NOT NULL AND payroll != ''",
      });

      log('data ${jsonEncode(data)}');

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      final items = response.data?[0];

      // debugger();

      if (items['status'] == 'Success') {
        final userExist = items['items'] != null && items['items'] is List;

        if (userExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            try {
              final listSelected = list[0];

              final UserModelWithPassword user = UserModelWithPassword(
                ptServer: server,
                password: password,
                ktp: listSelected['ktp'] ?? '',
                nama: listSelected['nama'] ?? '',
                jabatan: listSelected['jbt'] ?? '',
                email: listSelected['email'] ?? '',
                company: listSelected['comp'] ?? '',
                photo: listSelected['picture'],
                idKary: listSelected['IdKary'] ?? '',
                deptList: listSelected['dept'] ?? '',
                email2: listSelected['email2'] ?? '',
                imeiHp: listSelected['imei_hp'] ?? '',
                idUser: listSelected['id_user'] ?? '',
                noTelp1: listSelected['no_telp1'] ?? '',
                noTelp2: listSelected['no_telp2'] ?? '',
                fullname: listSelected['fullname'] ?? '',
                passwordUpdate: listSelected['pass_update'] ?? '',
              );

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
          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

          return AuthResponse.failure(
            errorCode: errorCode,
            message: message,
          );
        }
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        return AuthResponse.failure(
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
