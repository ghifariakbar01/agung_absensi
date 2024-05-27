import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../infrastructures/exceptions.dart';
import '../application/izin_list.dart';
import '../application/jenis_izin.dart';

class IzinListRemoteService {
  IzinListRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<List<IzinList>> getIzinList({
    required String username,
    required String pass,
    required DateTimeRange dateRange,
  }) async {
    try {
      final d1 = DateFormat('yyyy-MM-dd').format(dateRange.start);
      final d2 = DateFormat('yyyy-MM-dd').format(dateRange.end);

      final response = await _dio.get('/service_izin.asmx/getIzin',
          options: Options(
            headers: {
              'username': username,
              'pass': pass,
              'date_awal': d1,
              'date_akhir': d2,
              'server': 'testing'
            },
          ));

      final items = response.data;

      final _data = items['data'];

      if (items['message'] == 'SUCCESS') {
        log('_data is ${_data != null} ${_data.runtimeType}');

        final listExist = _data != null && _data is List;

        if (listExist) {
          if (_data.isNotEmpty) {
            final map = _data.map((e) => IzinList.fromJson(e)).toList();

            return map;
          } else {
            return [];
          }
        } else {
          final message = items['message'] as String?;
          final errorCode = items['status_code'] as int;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
        //
      } else {
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

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

  Future<List<JenisIzin>> getJenisIzin() async {
    try {
      final response = await _dio.post('/service_master.asmx/getJenisIzin',
          options: Options(contentType: 'text/plain', headers: {
            'server': 'testing',
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        final list = items['data'] as List;

        if (list.isNotEmpty) {
          return list
              .map((e) => JenisIzin.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          final message = 'List jenis cuti empty';
          final errorCode = 404;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
      } else {
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

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
