import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../constants/constants.dart';
import '../../../infrastructures/exceptions.dart';

class AbsenManualApproveRemoteService {
  AbsenManualApproveRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<Unit> approve({
    required int idAbsenMnl,
    required String username,
    required String pass,
    required String jenisApp,
    required String note,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post(
        '/service_absenmnl.asmx/approveAbsenmnl',
        options: Options(contentType: 'text/plain', headers: {
          'id_absenmnl': idAbsenMnl,
          'username': username,
          'pass': pass,
          'server': server,
          'jenis_app': jenisApp,
          'note': note,
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
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<Unit> batal({
    required int idAbsenMnl,
    required String username,
    required String pass,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post(
        '/service_absenmnl.asmx/approveAbsenmnl',
        options: Options(contentType: 'text/plain', headers: {
          'id_absenmnl': idAbsenMnl,
          'username': username,
          'pass': pass,
          'server': server,
          'jenis_app': 'batal',
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
