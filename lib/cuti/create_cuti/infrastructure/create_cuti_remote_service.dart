import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../../infrastructure/exceptions.dart';
import '../../../utils/string_utils.dart';
import '../application/alasan_cuti.dart';
import '../application/jenis_cuti.dart';

class CreateCutiRemoteService {
  CreateCutiRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbHrMstEmergency = 'hr_mst_emergency';
  static const String dbHrMstJenisCuti = 'hr_mst_jns_cuti';
  static const String dbCutiNew = 'hr_trs_cuti_new';
  static const String dbMstUser = 'mst_user';

  Future<Unit> submitCuti({
    required String jenisCuti,
    required String alasan,
    required String ket,
    required String tahunCuti,
    required int idUser,
    required int totalHari,
    required int sisaCuti,
    // date time
    required String tglStart,
    required DateTime tglAwalInDateTime,
    required DateTime tglAkhirInDateTime,
  }) async {
    try {
      final Map<String, String> submitCuti = {
        "command": "INSERT INTO $dbCutiNew ("
            "id_cuti, id_user, IdKary, jenis_cuti, alasan, ket, bulan_cuti, tahun_cuti, "
            "total_hari, sisa_cuti, tgl_end, tgl_end_hrd, tgl_start, tgl_start_hrd, spv_tgl, hrd_tgl, "
            "c_date, c_user, u_date, u_user) VALUES ("
            "(Select isnull(max(id_cuti),0) + 1 from $dbCutiNew), "
            "$idUser, "
            "(select IdKary from $dbMstUser where id_user = $idUser), "
            "'$jenisCuti', "
            "'$alasan', "
            "'$ket', "
            "(DATENAME (MONTH,'$tglStart')), "
            "'$tahunCuti', "
            "'${jenisCuti != "CR" ? "$totalHari , " : "14, "}', "
            "'${jenisCuti != "CR" ? "$sisaCuti" : " 0 ,"}"
            " ${jenisCuti != "CR" ? "${StringUtils.midnightDate(tglAkhirInDateTime)}" : "${StringUtils.midnightDate(tglAwalInDateTime.add(Duration(days: 13)))}"}"
            " ${jenisCuti != "CR" ? "${StringUtils.midnightDate(tglAkhirInDateTime)}" : "${StringUtils.midnightDate(tglAwalInDateTime.add(Duration(days: 13)))}"}"
            "'$tglStart', "
            "'$tglStart', "
            " getdate(), "
            "'0', "
            " getdate(), "
            "'0', ",
        "mode": "INSERT"
      };

      final data = _dioRequest;
      data.addAll(submitCuti);

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

  Future<List<JenisCuti>> getJenisCuti() async {
    try {
      final Map<String, String> submitSakit = {
        "command": "SELECT * FROM $dbHrMstJenisCuti ",
        "mode": "SELECT"
      };

      final data = _dioRequest;
      data.addAll(submitSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final list = items['items'] as List;

        if (list.isNotEmpty) {
          return list
              .map((e) => JenisCuti.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          final message = 'List jenis cuti empty';
          final errorCode = 404;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
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

  Future<List<AlasanCuti>> getAlasanEmergency() async {
    try {
      final Map<String, String> submitSakit = {
        "command": "SELECT * FROM $dbHrMstEmergency ",
        "mode": "SELECT"
      };

      final data = _dioRequest;
      data.addAll(submitSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final list = items['items'] as List;

        if (list.isNotEmpty) {
          return list
              .map((e) => AlasanCuti.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          final message = 'List alasan emergency empty';
          final errorCode = 404;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
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
