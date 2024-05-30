import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../infrastructures/exceptions.dart';
import '../application/phone_num.dart';

class SendWaRemoteService {
  SendWaRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'wa_msg_report';
  static const String dbMstUser = 'mst_user';

  String _formatPhone(int phoneNumber) {
    final phoneString = phoneNumber.toString();

    if (phoneString.startsWith('62')) {
      return phoneString;
    }

    if (phoneString.startsWith('+62')) {
      return phoneString.replaceAll('+', '');
    }

    if (phoneString.startsWith('8')) {
      return '62$phoneString'.replaceAll(' ', '');
    }

    if (phoneString.startsWith('08')) {
      return '$phoneString'.replaceAll('08', '62').replaceAll(' ', '');
    }

    throw AssertionError('Phone number not formatted properly : $phoneString');
  }

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
      final data = _dioRequest;

      final String phoneFormatted = _formatPhone(phone);

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
                "        '$phoneFormatted', "
                "        '$idUser', "
                "        '$idDept', "
                "        '1', "
                "        '$notifTitle', "
                "        GETDATE() )  ",
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

  Future<PhoneNum> getPhoneById({
    required int idUser,
  }) async {
    try {
      final data = _dioRequest;

      final Map<String, String> select = {
        'command': //
            " SELECT no_telp1, no_telp2 FROM $dbMstUser WHERE id_user = $idUser ",
        'mode': 'SELECT'
      };

      data.addAll(select);

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
            return PhoneNum.fromJson(list[0] as Map<String, dynamic>);
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
