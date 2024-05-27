import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';

import '../../../infrastructures/exceptions.dart';

class CreateSakitRemoteService {
  CreateSakitRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<Unit> submitSakit({
    required String username,
    required String pass,
    required int idUser,
    required String tglStart,
    required String tglEnd,
    required String ket,
    required String surat,
    String? server = 'testing',
  }) async {
    try {
      final response = await _dio.post(
        '/service_sakit.asmx/insertSakit',
        options: Options(
          contentType: 'text/plain',
          headers: {
            'username': username,
            'pass': pass,
            'id_user': idUser,
            'tgl_start': tglStart,
            'tgl_end': tglEnd,
            'ket': ket,
            'surat': surat,
            'server': server,
          },
        ),
      );

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

  Future<Unit> updateSakit({
    required int idSakit,
    required String username,
    required String pass,
    required int idUser,
    required String tglStart,
    required String tglEnd,
    required String ket,
    required String surat,
    String? server = 'testing',
  }) async {
    try {
      final response = await _dio.post(
        '/service_sakit.asmx/updateSakit',
        options: Options(
          contentType: 'text/plain',
          headers: {
            'username': username,
            'pass': pass,
            'id_sakit': idSakit,
            'id_user': idUser,
            'tgl_start': tglStart,
            'tgl_end': tglEnd,
            'ket': ket,
            'surat': surat,
            'server': server,
          },
        ),
      );

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

  Future<Unit> deleteSakit({
    required int idSakit,
    required String username,
    required String pass,
    String? server = 'testing',
  }) async {
    try {
      final response = await _dio.post(
        '/service_sakit.asmx/deleteSakit',
        options: Options(
          contentType: 'text/plain',
          headers: {
            'username': username,
            'pass': pass,
            'id_sakit': idSakit,
            'server': server,
          },
        ),
      );

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
