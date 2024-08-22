import 'dart:convert';
import 'package:face_net_authentication/utils/logging.dart';

import 'package:dio/dio.dart';

import '../../../infrastructures/exceptions.dart';
import '../application/wa_head.dart';

class WaHeadHelperRemoteService {
  WaHeadHelperRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'wa_msg_report';

  Future<List<WaHead>> getWaHead({
    required int idUser,
  }) async {
    try {
      // debugger();
      final data = _dioRequest;

      final Map<String, String> select = {
        'command': //
            " SELECT id_user_head, "
                " (SELECT idkary FROM mst_user WHERE id_user = mst_user_head.id_user_head) AS idkary, "
                " (SELECT nama FROM mst_user WHERE id_user = mst_user_head.id_user_head) AS nama, "
                " (SELECT no_telp1 FROM mst_user WHERE id_user = mst_user_head.id_user_head) AS telp1, "
                " (SELECT no_telp2 FROM mst_user WHERE id_user = mst_user_head.id_user_head) AS telp2, "
                " (SELECT id_dept FROM mst_user WHERE id_user = mst_user_head.id_user_head) AS id_dept "
                " FROM mst_user_head WHERE id_user = $idUser ",
        'mode': 'SELECT'
      };

      data.addAll(select);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      Log.info('data ${jsonEncode(data)}');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final listExist = items['items'] != null && items['items'] is List;

        if (listExist) {
          final list = items['items'] as List;
          return list
              .map((e) => WaHead.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          final message = "List wa head empty";
          final errorCode = 404;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
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
