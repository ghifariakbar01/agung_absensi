import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';
import 'package:intl/intl.dart';

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
          .format(DateTime.now().subtract(Duration(days: 30)));

      final response = await _dio.get('/service_cuti.asmx/getCuti',
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

      if (items['status_code'] == 200) {
        final listExist = _data != null && _data is List;

        if (listExist) {
          return unit;
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
}
