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

  Future<AuthResponse> signInACT(
      {required String userId,
      required String password,
      required String server}) async {
    try {
      final data = _dioRequestNotifier;

      data.addAll({
        "username": "$userId",
        "password": "$password",
        "mode": "SELECT",
        "command":
            //
            "SELECT *, " +
                "     (select nama from mst_dept where id_dept = A.id_dept) as dept, " +
                "     (select nama from mst_comp where id_comp = A.id_comp) as comp, " +
                "     (select nama from mst_jabatan where id_jbt = A.id_jbt) as jbt, " +
                "     (select full_akses from hr_user_grp where id_user_grp = A.id_user_grp) as full_akses,   " +
                "     isnull((select lihat from hr_user_grp where id_user_grp = A.id_user_grp),'0') as lihat, " +
                "     isnull((select baru from hr_user_grp where id_user_grp = A.id_user_grp),'0') as baru, " +
                "     isnull((select ubah from hr_user_grp where id_user_grp = A.id_user_grp),'0') as ubah, " +
                "     isnull((select hapus from hr_user_grp where id_user_grp = A.id_user_grp),'0') as hapus, " +
                "     isnull((select app_spv from hr_user_grp where id_user_grp = A.id_user_grp),'0') as spv, " +
                "     isnull((select app_mgr from hr_user_grp where id_user_grp = A.id_user_grp),'0') as mgr, " +
                "     isnull((select app_fin from hr_user_grp where id_user_grp = A.id_user_grp),'0') as fin, " +
                "     isnull((select app_coo from hr_user_grp where id_user_grp = A.id_user_grp),'0') as coo, " +
                "     isnull((select app_gm from hr_user_grp where id_user_grp = A.id_user_grp),'0') as gm,  " +
                "     isnull((select app_oth from hr_user_grp where id_user_grp = A.id_user_grp),'0') as oth " +
                " FROM mst_user A WHERE nama = '$userId'  AND payroll IS NOT NULL AND payroll != '' ",
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

              final UserModelWithPassword user = UserModelWithPassword.fromJson(
                      listSelected as Map<String, dynamic>)
                  .copyWith(ptServer: server, password: password);

              if (user.fin != null) {
                if (user.fin!.contains(",2,")) {
                  final userWFin = user.copyWith(isSpvOrHrd: true);

                  return AuthResponse.withUser(userWFin);
                } else {
                  final userWOFin = user.copyWith(isSpvOrHrd: false);

                  return AuthResponse.withUser(userWOFin);
                }
              } else {
                log('user $user');

                return AuthResponse.withUser(user);
              }
            } catch (e) {
              return AuthResponse.failure(
                errorCode: 00,
                message: 'Error parsing $e',
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

  Future<AuthResponse> signInARV(
      {required String userId,
      required String password,
      required String server}) async {
    try {
      final data = _dioRequestNotifier;

      data.addAll({
        "username": "$userId",
        "password": "$password",
        "mode": "SELECT",
        "command":
            //
            "SELECT *, " +
                "        (select nama from mst_dept where id_dept = A.id_dept) as dept,  " +
                "        (select nama from mst_comp where id_comp = A.id_comp) as comp,  " +
                "        (select nama from mst_jabatan where id_jbt = A.id_jbt) as jbt,  " +
                "        (select full_akses from mst_user_autho where id_user_grp = A.id_user_grp) as full_akses,  " +
                "        isnull((select lihat from mst_user_autho where id_user_grp = A.id_user_grp),'0') as lihat,  " +
                "        isnull((select baru from mst_user_autho where id_user_grp = A.id_user_grp),'0') as baru,  " +
                "        isnull((select ubah from mst_user_autho where id_user_grp = A.id_user_grp),'0') as ubah,  " +
                "        isnull((select hapus from mst_user_autho where id_user_grp = A.id_user_grp),'0') as hapus,  " +
                "        isnull((select app_spv from mst_user_autho where id_user_grp = A.id_user_grp),'0') as spv,  " +
                "        isnull((select app_mgr from mst_user_autho where id_user_grp = A.id_user_grp),'0') as mgr,  " +
                "        isnull((select app_fin from mst_user_autho where id_user_grp = A.id_user_grp),'0') as fin,  " +
                "        isnull((select app_coo from mst_user_autho where id_user_grp = A.id_user_grp),'0') as coo,  " +
                "        isnull((select app_gm from mst_user_autho where id_user_grp = A.id_user_grp),'0') as gm,  " +
                "        isnull((select app_oth from mst_user_autho where id_user_grp = A.id_user_grp),'0') as oth  " +
                " FROM mst_user A WHERE nama = '$userId'  AND payroll IS NOT NULL AND payroll != '' ",
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

              final UserModelWithPassword user = UserModelWithPassword.fromJson(
                      listSelected as Map<String, dynamic>)
                  .copyWith(ptServer: server, password: password);

              if (user.fin != null) {
                if (user.fin!.contains(",5101,")) {
                  final userWFin = user.copyWith(isSpvOrHrd: true);

                  return AuthResponse.withUser(userWFin);
                } else {
                  final userWOFin = user.copyWith(isSpvOrHrd: false);

                  return AuthResponse.withUser(userWOFin);
                }
              } else {
                log('user $user');

                return AuthResponse.withUser(user);
              }
            } catch (e) {
              return AuthResponse.failure(
                errorCode: 00,
                message: 'Error parsing $e',
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
