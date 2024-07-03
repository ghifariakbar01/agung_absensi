import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../constants/constants.dart';
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
    String? server = Constants.isDev ? 'testing' : 'live',
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

  Future<Unit> batal({
    required int idIzin,
    required String username,
    required String pass,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post(
        '/service_izin.asmx/approveIzin',
        options: Options(contentType: 'text/plain', headers: {
          'id_izin': idIzin,
          'username': username,
          'pass': pass,
          'server': server,
          'jenis_app': 'btl',
        }),
      );

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
