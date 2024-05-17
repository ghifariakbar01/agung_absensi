import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';
import 'package:face_net_authentication/mst_karyawan_cuti/application/mst_karyawan_cuti.dart';

import '../../../infrastructures/exceptions.dart';

class MstKaryawanCutiRemoteService {
  MstKaryawanCutiRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_mst_cuti_new';

  Future<MstKaryawanCuti> getSaldoMasterCuti({
    required int idUser,
  }) async {
    // 3. GET MASTER CUTI, BY USER ID
    try {
      final Map<String, String> selectMasterCuti = {
        'command': " SELECT * FROM $dbName  WHERE id_user = $idUser  ",
        'mode': 'SELECT'
      };

      final dataSelectMasterCuti = _dioRequest;
      dataSelectMasterCuti.addAll(selectMasterCuti);

      final response3 = await _dio.post('',
          data: jsonEncode(dataSelectMasterCuti),
          options: Options(contentType: 'text/plain'));

      final items3 = response3.data?[0];

      if (items3['status'] == 'Success') {
        final listExist = items3['items'] != null && items3['items'] is List;

        if (listExist) {
          if (items3['items'][0] != null) {
            return MstKaryawanCuti.fromJson(
                items3['items'][0] as Map<String, dynamic>);
          } else {
            throw RestApiExceptionWithMessage(
                404, 'items MstKaryawanCuti null');
          }
        }

        final message = 'List is empty';
        final errorCode = 404;

        throw RestApiExceptionWithMessage(errorCode, message);
      } else {
        final message = items3['error'] as String?;
        final errorCode = items3['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }

      //
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
