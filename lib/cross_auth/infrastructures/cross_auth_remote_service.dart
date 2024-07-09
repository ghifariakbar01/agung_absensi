import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../infrastructures/exceptions.dart';
import '../../user/application/user_model.dart';
import '../application/cross_auth_response.dart';

class CrossAuthRemoteService {
  CrossAuthRemoteService(this._dio);

  final Dio _dio;

  Future<CrossAuthResponse> crossToACT({
    required String server,
    required String userId,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "username": userId,
        "password": password,
        "server": server,
        "mode": "SELECT",
        "command": "SELECT  " +
            _commonQueryACT +
            "  FROM  "
                "    mst_user A JOIN hr_user B ON A.id_user = B.id_user "
                " WHERE  "
                "    nama = '$userId'  "
      };

      final response = await _dio.post(
        '',
        data: jsonEncode(data),
        options: Options(contentType: 'text/plain'),
      );

      log('data $data');
      log('response $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final userExist = items['items'] != null && items['items'] is List;

        if (userExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            try {
              final listSelected = list[0];

              final user = UserModelWithPassword.fromJson(
                listSelected as Map<String, dynamic>,
              ).copyWith(
                ptServer: server,
                password: password,
              );

              return CrossAuthResponse.withUser(user);
            } catch (e) {
              return CrossAuthResponse.failure(
                errorCode: 00,
                message: 'Error parsing $e',
              );
            }
          } else {
            return CrossAuthResponse.failure(
              errorCode: 00,
              message: 'User not found',
            );
          }
        } else {
          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

          return CrossAuthResponse.failure(
            errorCode: errorCode,
            message: message,
          );
        }
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        return CrossAuthResponse.failure(
          errorCode: errorCode,
          message: message,
        );
      }
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

  Future<CrossAuthResponse> crossToACTStl({
    required String server,
    required String userId,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "username": userId,
        "password": password,
        "server": server,
        "mode": "SELECT",
        "command": "SELECT  " +
            _commonQueryACT +
            "  FROM  "
                "    mst_user A JOIN hr_user B ON A.id_user = B.id_user "
                " WHERE  "
                "    nama = '$userId'  "
      };

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data $data');
      log('response $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final userExist = items['items'] != null && items['items'] is List;

        if (userExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            try {
              final listSelected = list[0];

              final user = UserModelWithPassword.fromJson(
                listSelected as Map<String, dynamic>,
              ).copyWith(
                ptServer: server,
                password: password,
              );

              return CrossAuthResponse.withUser(user);
            } catch (e) {
              return CrossAuthResponse.failure(
                errorCode: 00,
                message: 'Error parsing $e',
              );
            }
          } else {
            return CrossAuthResponse.failure(
              errorCode: 00,
              message: 'User not found',
            );
          }
        } else {
          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

          return CrossAuthResponse.failure(
            errorCode: errorCode,
            message: message,
          );
        }
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        return CrossAuthResponse.failure(
          errorCode: errorCode,
          message: message,
        );
      }
    } on DioException catch (e) {
      if ((e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout)) {
        return CrossAuthResponse.failure(
          errorCode: 404,
          message:
              'User setelah lintas server menutup aplikasi. Harap menyalakan internet dahulu.',
        );
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<CrossAuthResponse> crossToARV({
    required String server,
    required String userId,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "username": userId,
        "password": password,
        "server": server,
        "mode": "SELECT",
        "command": "SELECT *, " +
            _commonQueryARV +
            " FROM mst_user A WHERE nama = '$userId' ",
      };

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data $data');
      log('response $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final userExist = items['items'] != null && items['items'] is List;

        if (userExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            try {
              final listSelected = list[0];

              final user = UserModelWithPassword.fromJson(
                listSelected as Map<String, dynamic>,
              ).copyWith(
                ptServer: server,
                password: password,
              );

              return CrossAuthResponse.withUser(user);
            } catch (e) {
              return CrossAuthResponse.failure(
                errorCode: 00,
                message: 'Error parsing $e',
              );
            }
          } else {
            return CrossAuthResponse.failure(
              errorCode: 00,
              message: 'User not found',
            );
          }
        } else {
          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

          return CrossAuthResponse.failure(
            errorCode: errorCode,
            message: message,
          );
        }
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        return CrossAuthResponse.failure(
          errorCode: errorCode,
          message: message,
        );
      }
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

  Future<CrossAuthResponse> crossToARVStl({
    required String server,
    required String userId,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "username": userId,
        "password": password,
        "server": server,
        "mode": "SELECT",
        "command": "SELECT *, " +
            _commonQueryARV +
            " FROM mst_user A WHERE nama = '$userId' ",
      };

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data $data');
      log('response $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final userExist = items['items'] != null && items['items'] is List;

        if (userExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            try {
              final listSelected = list[0];

              final user = UserModelWithPassword.fromJson(
                listSelected as Map<String, dynamic>,
              ).copyWith(
                ptServer: server,
                password: password,
              );

              return CrossAuthResponse.withUser(user);
            } catch (e) {
              return CrossAuthResponse.failure(
                errorCode: 00,
                message: 'Error parsing $e',
              );
            }
          } else {
            return CrossAuthResponse.failure(
              errorCode: 00,
              message: 'User not found',
            );
          }
        } else {
          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

          return CrossAuthResponse.failure(
            errorCode: errorCode,
            message: message,
          );
        }
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        return CrossAuthResponse.failure(
          errorCode: errorCode,
          message: message,
        );
      }
    } on DioException catch (e) {
      if ((e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout)) {
        return CrossAuthResponse.failure(
          errorCode: 404,
          message:
              'User setelah lintas server menutup aplikasi.\nHarap menggunakan internet dahulu.',
        );
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}

const String _commonQueryACT = "    A.*, "
    "    (SELECT nama FROM mst_dept WHERE id_dept = A.id_dept) AS dept, "
    "    (SELECT nama FROM mst_comp WHERE id_comp = A.id_comp) AS comp, "
    "    (SELECT nama FROM mst_jabatan WHERE id_jbt = A.id_jbt) AS jbt, "
    "    ISNULL((SELECT full_akses FROM hr_user_grp WHERE id_user_grp = B.id_user_grp), 'false') AS full_akses, "
    "    ISNULL((SELECT lihat FROM hr_user_grp WHERE id_user_grp = B.id_user_grp), '0') AS lihat, "
    "    ISNULL((SELECT baru FROM hr_user_grp WHERE id_user_grp = B.id_user_grp), '0') AS baru, "
    "    ISNULL((SELECT ubah FROM hr_user_grp WHERE id_user_grp = B.id_user_grp), '0') AS ubah, "
    "    ISNULL((SELECT hapus FROM hr_user_grp WHERE id_user_grp = B.id_user_grp), '0') AS hapus, "
    "    ISNULL((SELECT app_spv FROM hr_user_grp WHERE id_user_grp = B.id_user_grp), '0') AS spv, "
    "    ISNULL((SELECT app_mgr FROM hr_user_grp WHERE id_user_grp = B.id_user_grp), '0') AS mgr, "
    "    ISNULL((SELECT app_fin FROM hr_user_grp WHERE id_user_grp = B.id_user_grp), '0') AS fin, "
    "    ISNULL((SELECT app_coo FROM hr_user_grp WHERE id_user_grp = B.id_user_grp), '0') AS coo, "
    "    ISNULL((SELECT app_gm FROM hr_user_grp WHERE id_user_grp = B.id_user_grp), '0') AS gm, "
    "    ISNULL((SELECT app_oth FROM hr_user_grp WHERE id_user_grp = B.id_user_grp), '0') AS oth, "
    "    ISNULL((CONCAT(A.id_user,',') + (select LTRIM(str(id_user)) + ',' from mst_user_head where id_user_head = A.id_user for xml path(''))), CONCAT(A.id_user, ',')) as staf";

const String _commonQueryARV = "        (select nama from mst_dept where id_dept = A.id_dept) as dept,  " +
    "        (select nama from mst_comp where id_comp = A.id_comp) as comp,  " +
    "        (select nama from mst_jabatan where id_jbt = A.id_jbt) as jbt,  " +
    "        isnull((select full_akses from mst_user_autho where id_user_grp = A.id_user_grp), 'false') as full_akses,   " +
    "        isnull((select lihat from mst_user_autho where id_user_grp = A.id_user_grp),'0') as lihat,  " +
    "        isnull((select baru from mst_user_autho where id_user_grp = A.id_user_grp),'0') as baru,  " +
    "        isnull((select ubah from mst_user_autho where id_user_grp = A.id_user_grp),'0') as ubah,  " +
    "        isnull((select hapus from mst_user_autho where id_user_grp = A.id_user_grp),'0') as hapus,  " +
    "        isnull((select app_spv from mst_user_autho where id_user_grp = A.id_user_grp),'0') as spv,  " +
    "        isnull((select app_mgr from mst_user_autho where id_user_grp = A.id_user_grp),'0') as mgr,  " +
    "        isnull((select app_fin from mst_user_autho where id_user_grp = A.id_user_grp),'0') as fin,  " +
    "        isnull((select app_coo from mst_user_autho where id_user_grp = A.id_user_grp),'0') as coo,  " +
    "        isnull((select app_gm from mst_user_autho where id_user_grp = A.id_user_grp),'0') as gm,  " +
    "        isnull((select app_oth from mst_user_autho where id_user_grp = A.id_user_grp),'0') as oth,  " +
    "        ISNULL((CONCAT(A.id_user,',') + (select LTRIM(str(id_user)) + ',' from mst_user_head where id_user_head = A.id_user for xml path(''))), CONCAT(A.id_user, ',')) as staf";
