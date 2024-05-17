import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../infrastructures/exceptions.dart';
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

  Future<List<SakitList>> getSakitList({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    try {
      // debugger();
      final data = _dioRequest;

      final d1 = DateFormat('yyyy-MM-dd').format(dateRange.start);
      final d2 = DateFormat('yyyy-MM-dd').format(dateRange.end);

      final Map<String, String> select = {
        'command': //
            " SELECT " +
                " $dbName.*, " +
                " $dbMstUser.payroll, " +
                " $dbMstUser.id_dept, " +
                " $dbMstUser.no_telp1, " +
                " $dbMstUser.no_telp2, " +
                " $dbMstUser.fullname, " +
                " (SELECT nama FROM mst_comp WHERE id_comp = $dbMstUser.id_comp) AS comp, " +
                " (SELECT nama FROM mst_dept WHERE id_dept = $dbMstUser.id_dept) AS dept, " +
                " (SELECT COUNT(id_sakit) FROM $dbDetail WHERE id_sakit = $dbName.id_sakit )AS qty_foto  FROM $dbName " +
                " JOIN " +
                " $dbMstUser ON $dbName.id_user = $dbMstUser.id_user "
                    " WHERE   "
                    "  $dbName.c_user    "
                    "                 LIKE '%$searchUser%'    "
                    "       AND    "
                    "           $dbName.c_date    "
                    "                 BETWEEN '$d1' AND '$d2'    " +
                " ORDER BY " +
                " $dbName.c_date DESC " +
                " OFFSET " +
                " $page * 20 ROWS FETCH NEXT 20 ROWS ONLY",
        'mode': 'SELECT'
      };

      log('query ${select.entries.where((element) => element.key == 'command').first}');

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
            return [];
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

  Future<List<SakitList>> getSakitListLimitedAccess({
    required int page,
    required String staff,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    try {
      // debugger();
      log('page $page');
      final data = _dioRequest;

      final d1 = DateFormat('yyyy-MM-dd').format(dateRange.start);
      final d2 = DateFormat('yyyy-MM-dd').format(dateRange.end);

      final Map<String, String> select = {
        'command': //
            " SELECT " +
                " $dbName.*, " +
                " $dbMstUser.payroll, " +
                " $dbMstUser.id_dept, " +
                " $dbMstUser.no_telp1, " +
                " $dbMstUser.no_telp2, " +
                " $dbMstUser.fullname, " +
                " (SELECT nama FROM mst_comp WHERE id_comp = $dbMstUser.id_comp) AS comp, " +
                " (SELECT nama FROM mst_dept WHERE id_dept = $dbMstUser.id_dept) AS dept, " +
                " (SELECT COUNT(id_sakit) FROM $dbDetail " +
                " FROM " +
                " $dbName " +
                " JOIN " +
                " $dbMstUser ON $dbName.id_user = $dbMstUser.id_user " +
                " WHERE $dbName.id_user IN ($staff) " +
                "  AND id_sakit = $dbName.id_sakit ) AS qty_foto "
                    "       AND    "
                    "           $dbName.c_user    "
                    "                 LIKE '%$searchUser%'    "
                    "       AND    "
                    "           $dbName.c_date    "
                    "                 BETWEEN '$d1' AND '$d2'    " +
                " ORDER BY " +
                " $dbName.c_date DESC " +
                " OFFSET "
                    " $page * 20 ROWS FETCH FIRST 20 ROWS ONLY ",
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
            return [];
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
