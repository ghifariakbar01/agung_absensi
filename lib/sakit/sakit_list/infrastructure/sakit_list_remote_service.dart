import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../../infrastructure/exceptions.dart';
import '../application/sakit_list.dart';

class SakitListRemoteService {
  SakitListRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_sakit';
  static const String dbDetail = 'hr_sakit_dtl';
  //
  static const String dbMstUser = 'mst_user';
  static const String dbMstUserHead = 'mst_user_head';

  Future<List<SakitList>> getSakitList({required int page}) async {
    try {
      // debugger();
      final data = _dioRequest;

      final Map<String, String> select = {
        'command': //
            " SELECT " +
                " $dbName.*, " +
                " $dbMstUser.payroll, " +
                " $dbMstUser.id_dept, " +
                " (SELECT nama from mst_dept WHERE id_dept = $dbMstUser.id_dept) AS dept, " +
                " (SELECT COUNT(id_sakit) FROM $dbDetail WHERE id_sakit = $dbName.id_sakit ) AS qty_foto "
                    " FROM " +
                " $dbName " +
                " JOIN " +
                " $dbMstUser ON $dbName.id_user = $dbMstUser.id_user " +
                " ORDER BY " +
                " $dbName.c_date DESC " +
                " OFFSET " +
                " ${page}0 ROWS FETCH FIRST 20 ROWS ONLY ",
        'mode': 'SELECT'
      };

      data.addAll(select);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      // log('data ${jsonEncode(data)}');
      // log('response page $page : $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        //
        final listExist = items['items'] != null && items['items'] is List;

        if (listExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            return list
                .map((e) => SakitList.fromJson(e as Map<String, dynamic>))
                .toList();
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
        //
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

  Future<List<SakitList>> getSakitListLimitedAccess({required int page}) async {
    try {
      // debugger();
      final data = _dioRequest;

      final Map<String, String> select = {
        'command': //
            " SELECT " +
                " $dbName.*, " +
                " $dbMstUser.payroll, " +
                " $dbMstUser.id_dept, " +
                " (SELECT nama from mst_dept WHERE id_dept = $dbMstUser.id_dept) AS dept, " +
                " (SELECT COUNT(id_sakit) FROM $dbDetail WHERE id_sakit = $dbName.id_sakit ) AS qty_foto "
                    " FROM " +
                " $dbName " +
                " JOIN " +
                " $dbMstUser ON $dbName.id_user = $dbMstUser.id_user " +
                " WHERE $dbName.id_user IN (SELECT id_user FROM $dbMstUserHead WHERE id_user_head = 1) " +
                " OR $dbName.id_user = 1 " +
                " ORDER BY " +
                " $dbName.c_date DESC " +
                " OFFSET " +
                " ${page}0 ROWS FETCH FIRST 20 ROWS ONLY ",
        'mode': 'SELECT'
      };

      data.addAll(select);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      // log('data ${jsonEncode(data)}');
      // log('response page $page : $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        //
        final listExist = items['items'] != null && items['items'] is List;

        if (listExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            return list
                .map((e) => SakitList.fromJson(e as Map<String, dynamic>))
                .toList();
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
        //
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
