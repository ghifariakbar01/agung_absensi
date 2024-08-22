import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../constants/constants.dart';
import '../../../infrastructures/exceptions.dart';

class CrossAuthServerRemoteService {
  CrossAuthServerRemoteService(this._dio);

  final Dio _dio;

  Future<Unit> getSakitList({
    required String username,
    required String pass,
  }) async {
    try {
      final response = await _dio.get('/service_auth.asmx/getAuth',
          options: Options(
            headers: {
              'username': username,
              'pass': pass,
              'server': Constants.isDev ? 'testing' : 'live',
            },
          ));

      final items = response.data;

      final _data = items['data'];

      if (items['status_code'] == 200) {
        final listExist = _data != null && _data is List;

        if (listExist) {
          return unit;
        } else {
          final message = items['message'] as String?;
          final errmessage = items['error_msg'] as String?;
          final errorCode = items['status_code'] as int;

          throw RestApiExceptionWithMessage(
            errorCode,
            "$errorCode : $message $errmessage ",
          );
        }
      } else {
        final message = items['message'] as String?;
        final errmessage = items['error_msg'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(
          errorCode,
          "$errorCode : $message $errmessage ",
        );
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
