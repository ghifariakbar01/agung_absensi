import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../infrastructures/exceptions.dart';
import '../application/dt_pc_list.dart';

class DtPcListRemoteService {
  DtPcListRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_dt';
  //
  static const String dbMstUser = 'mst_user';
  static const String dbMstUserHead = 'mst_user_head';

  final _commonQuery =
      "           (SELECT CONCAT(spv_nm, ' // ', spv_tgl)) AS app_spv, "
      "           (SELECT CONCAT(hrd_nm, ' // ', hrd_tgl)) AS app_hrd, "
      "           (SELECT CONCAT(u_user, ' // ', u_date)) AS u_by, "
      "           (SELECT CONCAT(c_user, ' // ', c_date)) AS c_by, "
      "           (SELECT idkary FROM $dbMstUser WHERE id_user = $dbName.id_user) AS idkar, "
      "           (SELECT id_dept FROM $dbMstUser WHERE id_user = $dbName.id_user) AS id_dept, "
      "           (SELECT payroll FROM $dbMstUser WHERE id_user = $dbName.id_user) AS payroll, "
      "           (SELECT no_telp1 FROM $dbMstUser WHERE id_user = $dbName.id_user) AS no_telp1, "
      "           (SELECT no_telp2 FROM $dbMstUser WHERE id_user = $dbName.id_user) AS no_telp2, "
      "           (SELECT fullname FROM $dbMstUser WHERE id_user = $dbName.id_user) AS fullname, "
      "           (SELECT nama FROM mst_dept WHERE id_dept = (SELECT id_dept FROM $dbMstUser WHERE id_user = $dbName.id_user)) AS dept, "
      "           (SELECT nama FROM mst_comp WHERE id_comp =  (SELECT id_comp FROM $dbMstUser WHERE id_user = $dbName.id_user) ) AS comp ";

  Future<List<DtPcList>> getDtPcList({
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
            " SELECT  "
                    "           *, " +
                _commonQuery +
                "      FROM "
                    "          $dbName "
                    "      WHERE "
                    "          id_dt IS NOT NULL "
                    "       AND    "
                    "           c_user    "
                    "                 LIKE '%$searchUser%'    "
                    "       AND    "
                    "           c_date    "
                    "                 BETWEEN '$d1' AND '$d2'    "
                    "      ORDER BY "
                    "          c_date DESC "
                    "      OFFSET "
                    "          $page * 20 ROWS FETCH FIRST 20 ROWS ONLY ",
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
                .map((e) => DtPcList.fromJson(e as Map<String, dynamic>))
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

  final _commonQuery2 =
      "           (SELECT CONCAT(spv_nm, ' // ', spv_tgl)) AS app_spv, "
      "           (SELECT CONCAT(hrd_nm, ' // ', hrd_tgl)) AS app_hrd, "
      "           (SELECT CONCAT(u_user, ' // ', u_date)) AS u_by, "
      "           (SELECT CONCAT(c_user, ' // ', c_date)) AS c_by, "
      "           (SELECT idkary FROM $dbMstUser WHERE id_user = $dbName.id_user) AS idkar, "
      "           (SELECT id_dept FROM $dbMstUser WHERE id_user = $dbName.id_user) AS id_dept, "
      "           (SELECT payroll FROM $dbMstUser WHERE id_user = $dbName.id_user) AS payroll, "
      "           (SELECT no_telp1 FROM $dbMstUser WHERE id_user = $dbName.id_user) AS no_telp1, "
      "           (SELECT no_telp2 FROM $dbMstUser WHERE id_user = $dbName.id_user) AS no_telp2, "
      "           (SELECT fullname FROM $dbMstUser WHERE id_user = $dbName.id_user) AS fullname, "
      "           (SELECT nama FROM mst_dept WHERE id_dept = (SELECT id_dept FROM $dbMstUser WHERE id_user = $dbName.id_user)) AS dept, "
      "           (SELECT nama FROM mst_comp WHERE id_comp =  (SELECT id_comp FROM $dbMstUser WHERE id_user = $dbName.id_user) ) AS comp ";

  Future<List<DtPcList>> getDtPcListLimitedAccess({
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
            " SELECT  "
                    "           *, " +
                _commonQuery2 +
                "      FROM "
                    "          $dbName "
                    "      WHERE "
                    "          $dbName.id_user IN ($staff) AND id_dt IS NOT NULL "
                    "       AND    "
                    "           c_user    "
                    "                 LIKE '%$searchUser%'    "
                    "       AND    "
                    "           c_date    "
                    "                 BETWEEN '$d1' AND '$d2'    "
                    "      ORDER BY "
                    "          c_date DESC "
                    "      OFFSET "
                    "          $page * 20 ROWS FETCH FIRST 20 ROWS ONLY ",
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
                .map((e) => DtPcList.fromJson(e as Map<String, dynamic>))
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
