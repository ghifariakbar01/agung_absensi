import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';

import '../../../infrastructures/exceptions.dart';

class IzinApproveRemoteService {
  IzinApproveRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<Unit> approve({
    required int idIzin,
    required String username,
    required String pass,
    required String jenisApp,
    required String note,
    required int tahun,
    String? server = 'testing',
  }) async {
    try {
      final response = await _dio.post(
        '/service_izin.asmx/approveIzin',
        options: Options(contentType: 'text/plain', headers: {
          'id_izin': idIzin,
          'username': username,
          'pass': pass,
          'server': server,
          'jenis_app': jenisApp,
          'note': note,
          'tahun': tahun
        }),
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

  Future<Unit> batal({
    required int idIzin,
    required String username,
    required String pass,
  }) async {
    try {
      final response = await _dio.post(
        '/service_izin.asmx/batalIzin',
        options: Options(contentType: 'text/plain', headers: {
          'id_izin': idIzin,
          'username': username,
          'pass': pass,
        }),
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
