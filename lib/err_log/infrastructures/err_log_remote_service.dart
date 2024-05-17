import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';

import '../../infrastructures/exceptions.dart';
import '../../utils/string_utils.dart';

class ErrLogRemoteService {
  ErrLogRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'log_error_finger_mobile';

  Future<Unit> sendLog(
      {required int idUser,
      required String nama,
      required String imeiDb,
      required String platform,
      required String imeiSaved,
      required String errMessage}) async {
    try {
      // debugger();
      final data = _dioRequest;

      final cDate = StringUtils.trimmedDate(DateTime.now());

      final commandUpdate =
          " INSERT INTO $dbName (c_date, c_user, id_user, imei_saved_hp, imei_db, platform, err_message) " +
              " VALUES ('$cDate', '$nama', $idUser, '$imeiSaved', '$imeiDb', '$platform', '$errMessage' ) ";

      final Map<String, String> select = {
        'command': commandUpdate,
        'mode': 'INSERT'
      };

      data.addAll(select);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');

      log('response $response');

      // debugger();

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        return unit;
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

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
