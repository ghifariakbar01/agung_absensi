import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/constants.dart';
import '../../../infrastructures/exceptions.dart';
import '../application/ganti_hari_list.dart';

class GantiHariListRemoteService {
  GantiHariListRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<List<GantiHariList>> getGantiHariList({
    required String username,
    required String pass,
    required DateTimeRange dateRange,
  }) async {
    try {
      final d1 = DateFormat('yyyy-MM-dd').format(dateRange.start);
      final d2 = DateFormat('yyyy-MM-dd').format(dateRange.end);

      final response = await _dio.get('/service_dayoff.asmx/getDayoff',
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

      if (items['message'] == 'SUCCESS') {
        log('_data is ${_data != null} ${_data.runtimeType}');

        final listExist = _data != null && _data is List;

        if (listExist) {
          if (_data.isNotEmpty) {
            final map = _data.map((e) => GantiHariList.fromJson(e)).toList();

            return map;
          } else {
            return [];
          }
        } else {
          final message = items['message'] as String?;
          final errorCode = items['status_code'] as int;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
      } else {
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
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
}
