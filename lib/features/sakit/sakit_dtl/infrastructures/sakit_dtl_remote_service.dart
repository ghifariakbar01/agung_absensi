import 'dart:convert';
import 'package:face_net_authentication/utils/logging.dart';

import 'package:dio/dio.dart';

import '../../../../infrastructures/exceptions.dart';
import '../application/sakit_dtl.dart';

class SakitDtlRemoteService {
  SakitDtlRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_sakit_dtl';

  Future<List<SakitDtl>> getSakitDetail({required int idSakit}) async {
    try {
      final data = _dioRequest;

      final Map<String, String> select = {
        'command': " SELECT * FROM $dbName WHERE id_sakit = $idSakit ",
        'mode': 'SELECT'
      };

      data.addAll(select);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      Log.info('data ${jsonEncode(data)}');
      Log.info('response page $idSakit : $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        //
        final listExist = items['items'] != null && items['items'] is List;

        if (listExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            return list.map((e) => SakitDtl.fromJson(e)).toList();
          } else {
            final message = items['error'] as String?;
            final errorCode = items['errornum'] as int;

            throw RestApiExceptionWithMessage(errorCode, message);
          }
        } else {
          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
        //
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
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
