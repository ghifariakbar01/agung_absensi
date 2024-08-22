import 'package:face_net_authentication/utils/logging.dart';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../constants/constants.dart';
import '../../../../infrastructures/exceptions.dart';
import '../application/mst_user_list.dart';
import '../application/tugas_dinas_list.dart';

class TugasDinasListRemoteService {
  TugasDinasListRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<List<TugasDinasList>> getTugasDinasList({
    required String username,
    required String pass,
    required DateTimeRange dateRange,
  }) async {
    try {
      final d1 = DateFormat('yyyy-MM-dd').format(dateRange.start);
      final d2 = DateFormat('yyyy-MM-dd').format(dateRange.end);

      final response = await _dio.get('/service_dinas.asmx/getDinas',
          options: Options(
            headers: {
              'username': username,
              'pass': pass,
              'date_awal': d1,
              'date_akhir': d2,
              'server': Constants.isDev ? 'testing' : 'live',
            },
          ));

      final items = response.data;

      final _data = items['data'];

      if (items['status_code'] == 200) {
        final listExist = _data != null && _data is List;

        if (listExist) {
          if (_data.isNotEmpty) {
            try {
              final map = _data.map((e) => TugasDinasList.fromJson(e)).toList();

              return map;
            } catch (e) {
              throw e;
            }
          } else {
            return [];
          }
        } else {
          final message = items['message'] as String?;
          final errmessage = items['error_msg'] as String?;
          final errorCode = items['status_code'] as int;

          throw RestApiExceptionWithMessage(
              errorCode, "$errorCode : $message $errmessage ");
        }
      } else {
        final message = items['message'] as String?;
        final errmessage = items['error_msg'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(
            errorCode, "$errorCode : $message $errmessage ");
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<List<MstUserList>> getMasterUserList() async {
    try {
      final response = await _dio.get('/service_master.asmx/getMasterUser',
          options: Options(
            headers: {
              'server': Constants.isDev ? 'testing' : 'live',
            },
          ));

      final items = response.data;

      final _data = items['data'];

      if (items['status_code'] == 200) {
        Log.info('_data is ${_data != null} ${_data.runtimeType}');

        final listExist = _data != null && _data is List;

        if (listExist) {
          if (_data.isNotEmpty) {
            try {
              final map = _data.map((e) => MstUserList.fromJson(e)).toList();

              return map;
            } catch (e) {
              Log.shout('error is $e');
              throw e;
            }
          } else {
            return [];
          }
        } else {
          final message = items['message'] as String?;
          final errmessage = items['error_msg'] as String?;
          final errorCode = items['status_code'] as int;

          throw RestApiExceptionWithMessage(
              errorCode, "$errorCode : $message $errmessage ");
        }
      } else {
        final message = items['message'] as String?;
        final errmessage = items['error_msg'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(
            errorCode, "$errorCode : $message $errmessage ");
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
