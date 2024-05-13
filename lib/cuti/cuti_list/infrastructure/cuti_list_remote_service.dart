import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../infrastructure/exceptions.dart';
import '../application/cuti_list.dart';

class CutiListRemoteService {
  CutiListRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_cuti_new';
  static const String dbDetail = 'hr_sakit_dtl';
  //
  static const String dbMstUser = 'mst_user';
  static const String dbMstUserHead = 'mst_user_head';
  //
  static const String dbKaryawan = 'karyawan';
  static const String dbMstDept = 'mst_dept';

  final _commonQueryList = "     $dbName.*, "
      "     (SELECT no_telp1 FROM $dbMstUser WHERE id_user = $dbName.id_user) AS no_telp1, "
      "     (SELECT no_telp2 FROM $dbMstUser WHERE id_user = $dbName.id_user) AS no_telp2, "
      "     (SELECT fullname FROM $dbMstUser WHERE id_user = $dbName.id_user) AS fullname, "
      "     (SELECT nama FROM mst_comp WHERE id_comp =  (SELECT id_comp FROM $dbMstUser WHERE id_user = $dbName.id_user) ) AS comp, "
      "     (SELECT pt FROM $dbKaryawan WHERE IdKary = $dbName.IdKary) AS pt, "
      "     (SELECT nama FROM $dbMstDept WHERE id_dept = (SELECT id_dept FROM $dbMstUser WHERE id_user = $dbName.id_user)) AS dept, "
      "     (SELECT id_dept FROM $dbMstUser WHERE id_user = $dbName.id_user) AS id_dept "
      " FROM "
      "     $dbName ";

  Future<List<CutiList>> getCutiList({
    required int page,
    required String searchUser,
    required DateTimeRange dateRange,
  }) async {
    try {
      final data = _dioRequest;

      final d1 = DateFormat('yyyy-MM-dd').format(dateRange.start);
      final d2 = DateFormat('yyyy-MM-dd').format(dateRange.end);

      final Map<String, String> select = {
        'command': //
            " SELECT " +
                _commonQueryList +
                " WHERE "
                    "     id_cuti IS NOT NULL "
                    "       AND    "
                    "           $dbName.c_user    "
                    "                 LIKE '%$searchUser%'    "
                    "       AND    "
                    "           $dbName.c_date    "
                    "                 BETWEEN '$d1' AND '$d2'    "
                    " ORDER BY "
                    "     $dbName.c_date DESC "
                    " OFFSET "
                    "     $page * 20 ROWS FETCH FIRST 20 ROWS ONLY ",
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
                .map((e) => CutiList.fromJson(e as Map<String, dynamic>))
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

  final _commonQueryLimited = "          $dbName.*, "
      "          $dbMstUser.no_telp1, "
      "          $dbMstUser.no_telp2, "
      "          $dbMstUser.fullname, "
      "          $dbKaryawan.pt, "
      "          $dbMstDept.nama AS dept, "
      "          (SELECT nama FROM mst_comp WHERE id_comp = (SELECT id_comp FROM $dbMstUser WHERE id_user = $dbName.id_user)) AS comp, "
      "          (SELECT id_dept FROM $dbMstUser WHERE id_user = $dbName.id_user) AS id_dept "
      "      FROM "
      "          $dbName "
      "      JOIN "
      "           $dbMstUser ON $dbName.id_user = $dbMstUser.id_user "
      "      JOIN "
      "          $dbKaryawan ON $dbName.IdKary = $dbKaryawan.IdKary "
      "      JOIN "
      "          $dbMstDept ON $dbMstUser.id_dept = $dbMstDept.id_dept ";

  Future<List<CutiList>> getCutiListLimitedAccess({
    required int page,
    required String staff,
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
                _commonQueryLimited +
                "      WHERE    "
                    "           $dbName.id_user IN ($staff) "
                    "       AND     "
                    "           $dbName.id_cuti IS NOT NULL "
                    "       AND    "
                    "           $dbName.c_user    "
                    "                 LIKE '%$searchUser%'    "
                    "       AND    "
                    "           $dbName.c_date    "
                    "                 BETWEEN '$d1' AND '$d2'    "
                    "      ORDER BY "
                    "          $dbName.c_date DESC "
                    "      OFFSET "
                    "          $page * 20 ROWS FETCH FIRST 20 ROWS ONLY ",
        'mode': 'SELECT'
      };

      data.addAll(select);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response page $page : $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        //
        final listExist = items['items'] != null && items['items'] is List;

        if (listExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            return list
                .map((e) => CutiList.fromJson(e as Map<String, dynamic>))
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
