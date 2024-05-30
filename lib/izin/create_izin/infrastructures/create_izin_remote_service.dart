import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../constants/constants.dart';
import '../../../infrastructures/exceptions.dart';

class CreateIzinRemoteService {
  CreateIzinRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<Unit> submitIzin({
    required String username,
    required String pass,
    required int idUser,
    required int idMstIzin,
    required String ket,
    required String cUser,
    required String tglEnd,
    required String tglStart,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_izin.asmx/insertIzin',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'server': server,
            'id_user': idUser,
            'tgl_start': tglStart,
            'tgl_end': tglEnd,
            'ket': ket,
            'id_mst_izin': idMstIzin,
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

  Future<Unit> updateIzin({
    required int idIzin,
    required String username,
    required String pass,
    required int idUser,
    required int idMstIzin,
    required String ket,
    required String tglEnd,
    required String tglStart,
    required String noteSpv,
    required String noteHrd,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_izin.asmx/updateIzin',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'server': server,
            'id_izin': idIzin,
            'tgl_start': tglStart,
            'tgl_end': tglEnd,
            'id_mst_izin': idMstIzin,
            'ket': ket,
            'spv_note': noteSpv,
            'hrd_note': noteHrd,
          }));

      log(
        'username' + username,
      );
      log(
        'pass' + pass,
      );
      log('server' + server!);
      log(
        'id_izin' + idIzin.toString(),
      );
      log(
        'tgl_start' + tglStart,
      );
      log(
        'tgl_end' + tglEnd,
      );
      log(
        'id_mst_izin' + idMstIzin.toString(),
      );
      log(
        'ket' + ket,
      );
      log(
        'spv_note' + noteSpv,
      );
      log(
        'hrd_note' + noteHrd,
      );

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
      } else {
        final message = items['error_message'] as String?;
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

  Future<Unit> deleteIzin({
    required String username,
    required String pass,
    required int idIzin,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_izin.asmx/deleteIzin',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_izin': idIzin,
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
}
