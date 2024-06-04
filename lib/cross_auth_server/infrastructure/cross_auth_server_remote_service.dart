import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:intl/intl.dart';

import '../../constants/constants.dart';
import '../../infrastructures/exceptions.dart';

class CrossAuthServerRemoteService {
  CrossAuthServerRemoteService(this._dio);

  final Dio _dio;

  Future<Unit> getCutiList({
    required String username,
    required String pass,
  }) async {
    try {
      final d1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final d2 = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 1)));

      final response = await _dio.get('/service_cuti.asmx/getCuti',
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

      if (items['status_code'] == 200) {
        final listExist = _data != null && _data is List;

        if (listExist) {
          return unit;
        } else {
          final message = items['message'] as String?;
          final errmessage = items['error_msg'] as String?;
          final errorCode = items['status_code'] as int;

          throw RestApiExceptionWithMessage(
              errorCode, "$errorCode : $message $errmessage ");
        }
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
