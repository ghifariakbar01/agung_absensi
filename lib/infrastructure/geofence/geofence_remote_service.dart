import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:face_net_authentication/infrastructure/dio_extensions.dart';
import 'package:face_net_authentication/infrastructure/dio_request.dart';

import '../../application/geofence/geofence_response.dart';
import '../../application/user/user_model.dart';
import '../exceptions.dart';

class GeofenceRemoteService {
  GeofenceRemoteService(this._dio, this._userModelWithPassword);

  final Dio _dio;
  final UserModel _userModelWithPassword;
  static const String dbName = 'mst_geofence';

  Future<List<GeofenceResponse>> getGeofenceList() async {
    try {
      final data = dioRequest;

      data.addAll({
        "username": "${_userModelWithPassword.nama}",
        "password": "${_userModelWithPassword.password}",
        "mode": "SELECT",
        "command": "SELECT id_geof, nm_lokasi, geof FROM $dbName",
      });

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');

      log('response ${response}');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final userExist = items['items'] != null && items['items'] is List;

        if (userExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            final List<GeofenceResponse> geofences = [];
            list.forEach((element) {
              geofences.add(GeofenceResponse.fromJson(element));
            });

            return geofences;
          } else {
            throw RestApiException(09);
          }
        } else {
          throw RestApiException(09);
        }
      } else {
        throw RestApiException(10);
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
    }
  }
}
