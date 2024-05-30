import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../constants/constants.dart';
import '../../../infrastructures/exceptions.dart';
import '../application/jenis_absen.dart';

class CreateAbsenManualRemoteService {
  CreateAbsenManualRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<Unit> submitAbsenManual({
    required String username,
    required String pass,
    required int idUser,
    required String ket,
    required String tgl,
    required String jamAwal,
    required String jamAkhir,
    required String jenisAbsen,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_absenmnl.asmx/insertAbsenmnl',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_user': idUser,
            'server': server,
            'tgl': tgl,
            'jam_awal': jamAwal,
            'jam_akhir': jamAkhir,
            'ket': ket,
            'jenis_absen': 'MNL',
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

  Future<Unit> updateAbsenManual({
    required String username,
    required String pass,
    required int idUser,
    required int idAbsenmnl,
    required String ket,
    required String tgl,
    required String jamAwal,
    required String jamAkhir,
    required String jenisAbsen,
    required String noteSpv,
    required String noteHrd,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_absenmnl.asmx/updateAbsenmnl',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_user': idUser,
            'server': server,
            'id_absenmnl': idAbsenmnl,
            'tgl': tgl,
            'jam_awal': jamAwal,
            'jam_akhir': jamAkhir,
            'ket': ket,
            'spv_note': noteSpv,
            'hrd_note': noteHrd,
            'jenis_absen': 'MNL',
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

  Future<Unit> deleteAbsenmnl({
    required String username,
    required String pass,
    required int idAbsenmnl,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post('/service_absenmnl.asmx/deleteAbsenmnl',
          options: Options(contentType: 'text/plain', headers: {
            'username': username,
            'pass': pass,
            'id_absenmnl': idAbsenmnl,
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

  Future<List<JenisAbsen>> getJenisAbsen() async {
    try {
      final response = await _dio.post('/service_master.asmx/getJenisAbsen',
          options: Options(contentType: 'text/plain', headers: {
            'server': Constants.isDev ? 'testing' : 'live',
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        final list = items['data'] as List;

        if (list.isNotEmpty) {
          return list
              .map((e) => JenisAbsen.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          final message = 'List jenis cuti empty';
          final errorCode = 404;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
      } else {
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

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
