import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../constants/constants.dart';
import '../../../infrastructures/exceptions.dart';
import '../application/absen_ganti_hari.dart';

class CreateGantiHariRemoteService {
  CreateGantiHariRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<Unit> submitGantiHari({
    required int idUser,
    required int idAbsen,
    required String username,
    required String pass,
    required String ket,
    required String tglOff,
    required String tglGanti,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_dayoff.asmx/insertDayoff',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_user': idUser,
            'server': server,
            'tgl_start': tglOff,
            'tgl_end': tglGanti,
            'ket': ket,
            'id_absen': idAbsen,
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
      } else {
        final message = items['message'] as String?;
        final errmessage = items['error_msg'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(
            errorCode, "$errorCode : $message $errmessage ");
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

  Future<Unit> updateGantiHari({
    required int idDayOff,
    required int idUser,
    required int idAbsen,
    required String username,
    required String pass,
    required String ket,
    required String tglOff,
    required String tglGanti,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_dayoff.asmx/updateDayoff',
          options: Options(contentType: 'text/plain', headers: {
            'id_dayoff': idDayOff,
            'username': username,
            'pass': pass,
            'id_user': idUser,
            'server': server,
            'tgl_start': tglOff,
            'tgl_end': tglGanti,
            'ket': ket,
            'id_absen': idAbsen,
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
      } else {
        final message = items['message'] as String?;
        final errmessage = items['error_msg'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(
            errorCode, "$errorCode : $message $errmessage ");
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

  Future<List<AbsenGantiHari>> getAbsenGantiHari() async {
    try {
      final response = await _dio.post('/service_master.asmx/getJadwalAbsen',
          options: Options(contentType: 'text/plain', headers: {
            'server': Constants.isDev ? 'testing' : 'live',
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        final list = items['data'] as List;

        if (list.isNotEmpty) {
          return list
              .map((e) => AbsenGantiHari.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          final message = 'List absen ganti hari empty';
          final errorCode = 404;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
      } else {
        final message = items['message'] as String?;
        final errmessage = items['error_msg'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(
            errorCode, "$errorCode : $message $errmessage ");
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

  Future<Unit> deleteGantiHari({
    required String username,
    required String pass,
    required int idDayOff,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_dayoff.asmx/deleteDayoff',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_dayoff': idDayOff,
            'server': server,
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
      } else {
        final message = items['message'] as String?;
        final errmessage = items['error_msg'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(
            errorCode, "$errorCode : $message $errmessage ");
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
