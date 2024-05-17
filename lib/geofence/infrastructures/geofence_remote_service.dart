import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:face_net_authentication/infrastructures/dio_extensions.dart';

import '../../infrastructures/exceptions.dart';
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

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');

      log('response $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final listExist = items['items'] != null && items['items'] is List;

        if (listExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            final List<GeofenceResponse> geofences = [];
            list.forEach((element) {
              geofences.add(GeofenceResponse.fromJson(element));
            });

            return geofences;
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
    } on FormatException {
      throw FormatException();
    } on DioError catch (e) {
      if (e.isNoConnectionError || e.isConnectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    } catch (e) {
      throw e;
    }
  }
}
