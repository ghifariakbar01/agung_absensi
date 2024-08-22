import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../infrastructures/exceptions.dart';
import '../application/geofence_response.dart';

class GeofenceRemoteService {
  GeofenceRemoteService(this._dio, this._dioRequest);

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'mst_geofence';

  Future<List<GeofenceResponse>> getGeofenceList() async {
    try {
      final data = _dioRequest;

      data.addAll({
        "mode": "SELECT",
        "command":
            "SELECT id_geof, nm_lokasi, geof, radius FROM $dbName WHERE app_sta = '1'",
      });

      final response = await _dio.post(
        '',
        data: jsonEncode(data),
        options: Options(contentType: 'text/plain'),
      );

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final listExist = items['items'] != null && items['items'] is List;

        if (listExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            return list.map((e) => GeofenceResponse.fromJson(e)).toList();
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
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
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
    } catch (_) {
      rethrow;
    }
  }
}
