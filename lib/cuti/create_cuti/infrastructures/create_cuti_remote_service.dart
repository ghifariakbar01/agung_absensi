import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../constants/constants.dart';
import '../../../infrastructures/exceptions.dart';
import '../application/alasan_cuti.dart';
import '../application/jenis_cuti.dart';

class CreateCutiRemoteService {
  CreateCutiRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<Unit> updateCuti({
    required String username,
    required String pass,
    required int idCuti,
    required String jenisCuti,
    required String tglStart,
    required String tglEnd,
    required String ket,
    required String alasan,
    required String spvNote,
    required String hrdNote,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_cuti.asmx/updateCuti',
          options: Options(
            contentType: 'text/plain',
            headers: {
              'username': username,
              'pass': pass,
              'id_cuti': idCuti,
              'jenis_cuti': jenisCuti,
              'tgl_start': tglStart,
              'tgl_end': tglEnd,
              'ket': ket,
              'alasan': alasan,
              'spv_note': spvNote,
              'hrd_note': hrdNote,
              'server': server,
            },
          ));

      final items = response.data;

      log('baseUrl : ${_dio.options.baseUrl}');
      log('headers : ${_dio.options.headers}');

      if (items['status_code'] == 200) {
        return unit;
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

  Future<Unit> submitCuti({
    required String username,
    required String pass,
    required int idUser,
    required String jenisCuti,
    required String tglStart,
    required String tglEnd,
    required String ket,
    required String alasan,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_cuti.asmx/insertCuti',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_user': idUser,
            'jenis_cuti': jenisCuti,
            'tgl_start': tglStart,
            'tgl_end': tglEnd,
            'ket': ket,
            'alasan': alasan,
            'server': server,
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
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

  Future<Unit> deleteCuti({
    required String username,
    required String pass,
    required int idCuti,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_cuti.asmx/deleteCuti',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_cuti': idCuti,
            'server': server,
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
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

  Future<List<JenisCuti>> getJenisCuti() async {
    try {
      final response = await _dio.post('/service_master.asmx/getJenisCuti',
          options: Options(contentType: 'text/plain', headers: {
            'server': Constants.isDev ? 'testing' : 'live',
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        final list = items['data'] as List;

        if (list.isNotEmpty) {
          return list
              .map((e) => JenisCuti.fromJson(e as Map<String, dynamic>))
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

  Future<List<AlasanCuti>> getAlasanEmergency() async {
    try {
      final response = await _dio.post('/service_master.asmx/getEmergency',
          options: Options(contentType: 'text/plain', headers: {
            'server': Constants.isDev ? 'testing' : 'live',
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        final list = items['data'] as List;

        if (list.isNotEmpty) {
          return list
              .map((e) => AlasanCuti.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          final message = 'List jenis getEmergency';
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
