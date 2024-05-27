import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';

import '../../../infrastructures/exceptions.dart';

class CreateIzinRemoteService {
  CreateIzinRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<Unit> submitIzin({
    required String username,
    required String pass,
    required int idUser,
    required int idMstIzin,
    required int totalHari,
    required String ket,
    required String cUser,
    required String tglEnd,
    required String tglStart,
    String? server = 'testing',
  }) async {
    try {
      final response = await _dio.post('/service_izin.asmx/insertCuti',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'server': server,
            'id_user': idUser,
            'tgl_start': tglStart,
            'tgl_end': tglEnd,
            'ket': ket,
            'id_mst_izin': idMstIzin,
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
      } else {
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

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

  Future<Unit> updateIzin({
    required int idIzin,
    required String username,
    required String pass,
    required int idUser,
    required int idMstIzin,
    required String ket,
    required String tglEnd,
    required String tglStart,
    required String noteSpv,
    required String noteHrd,
    String? server = 'testing',
  }) async {
    try {
      final response = await _dio.post('/service_izin.asmx/updateIzin',
          options: Options(contentType: 'text/plain', headers: {
            'id_izin': idIzin,
            'username': username,
            'pass': pass,
            'server': server,
            'id_user': idUser,
            'tgl_start': tglStart,
            'tgl_end': tglEnd,
            'ket': ket,
            'id_mst_izin': idMstIzin,
            'note_spv': idMstIzin,
            'note_hrd': idMstIzin,
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
      } else {
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

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

  Future<Unit> deleteIzin({
    required String username,
    required String pass,
    required int idIzin,
    String? server = 'testing',
  }) async {
    try {
      final response = await _dio.post('/service_izin.asmx/deleteIzin',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_izin': idIzin,
            'server': server,
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
      } else {
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

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
