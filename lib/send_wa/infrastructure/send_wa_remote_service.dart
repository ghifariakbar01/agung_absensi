import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../../infrastructure/exceptions.dart';

class SendWaRemoteService {
  SendWaRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'wa_msg_report';

  Future<Unit> sendWa(
      {
      //
      required int phone,
      required int idUser,
      required int idDept,
      required String notifTitle,
      required String notifContent
      //
      }) async {
    try {
      // debugger();
      final data = _dioRequest;

      final Map<String, String> select = {
        'command': //
            " INSERT INTO $dbName ( "
                " id_msg, id_contact, msg_cont, msg_type, msg_status, nama_contact, number, "
                " id_user, id_dept, id_link, msg_desc, c_date ) "
                "      VALUES ( "
                "        (SELECT ISNULL(MAX(id_msg), 0) + 1 FROM $dbName), "
                "        '1', "
                "        '$notifContent', "
                "        'Personal', "
                "        'Queued', "
                "        '$notifTitle', "
                "        '$phone', "
                "        '$idUser', "
                "        '$idDept', "
                "        '1', "
                "        '$notifTitle', "
                "        GETDATE() , ",
        'mode': 'INSERT'
      };

      data.addAll(select);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');

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
