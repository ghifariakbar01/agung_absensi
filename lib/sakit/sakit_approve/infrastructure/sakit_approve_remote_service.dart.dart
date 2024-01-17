import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../../infrastructure/exceptions.dart';

class SakitApproveRemoteService {
  SakitApproveRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_sakit';
  static const String dbDetail = 'hr_sakit_dtl';
  //

  Future<Unit> approveSpv(
      {required int idSakit,
      required String nama,
      required String note}) async {
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbName SET "
                " spv_nm = '$nama', " +
            " spv_sta = 1, " +
            " spv_tgl = getdate(), " +
            " spv_note = $note, " +
            " WHERE id_sakit = $idSakit ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
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
