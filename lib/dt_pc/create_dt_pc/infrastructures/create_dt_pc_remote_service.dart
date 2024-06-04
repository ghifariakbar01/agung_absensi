import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../constants/constants.dart';
import '../../../infrastructures/exceptions.dart';

class CreateDtPcRemoteService {
  CreateDtPcRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<Unit> submitDtPc({
    required int idUser,
    required String username,
    required String pass,
    required String ket,
    required String dtTgl,
    required String jam,
    required String kategori,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_dt.asmx/insertDt',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_user': idUser,
            'dt_tgl': dtTgl,
            'jam': jam,
            'ket': ket,
            'kategori': kategori,
            'server': Constants.isDev ? 'testing' : 'live',
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
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

  Future<Unit> updateDtPc({
    required int id,
    required int idUser,
    required String username,
    required String pass,
    required String ket,
    required String dtTgl,
    required String jam,
    required String kategori,
    required String noteSpv,
    required String noteHrd,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_dt.asmx/updateDt',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_dt': id,
            'id_user': idUser,
            'dt_tgl': dtTgl,
            'jam': jam,
            'ket': ket,
            'kategori': kategori,
            'spv_note': noteSpv,
            'hrd_note': noteHrd,
            'server': Constants.isDev ? 'testing' : 'live',
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
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

  Future<Unit> deleteDtPc({
    required int idDt,
    required String username,
    required String pass,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_dt.asmx/deleteDt',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_dt': idDt,
            'server': Constants.isDev ? 'testing' : 'live',
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
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
