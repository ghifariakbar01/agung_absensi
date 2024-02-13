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
  static const String dbMstCutiNew = 'hr_mst_cuti_new';
  static const String dbCutiNew = 'hr_trs_cuti_new';
  static const String dbMstUser = 'mst_user';

  Future<Unit> updateCuti({
    required int idCuti,
    //
    required String jenisCuti,
    required String alasan,
    required String ket,
    required String tahunCuti,
    //
    required String nama,
    required int idUser,
    required int sisaCuti,
    //
    required int jumlahHari,
    required int hitungLibur,
    // date time
    required DateTime tglAwalInDateTime,
    required DateTime tglAkhirInDateTime,
  }) async {
    try {
      final Map<String, String> updateCuti = {
        "command": "UPDATE $dbCutiNew SET "
            "id_user = $idUser, " // id_user
            "IdKary = (SELECT IdKary FROM $dbMstUser WHERE id_user = $idUser), " // IdKary
            "jenis_cuti = '$jenisCuti', " // jenis_cuti
            "alasan = '$alasan', " // alasan
            "ket = '$ket', " // ket
            "bulan_cuti = DATENAME(MONTH, '${tglAwalInDateTime.toString()}'), " // bulan_cuti
            "tahun_cuti = '$tahunCuti', " // tahun_cuti
            "total_hari = ${jenisCuti != "CR" ? "DATEDIFF(DAY, '${tglAwalInDateTime.toString()}', '${tglAkhirInDateTime.toString()}') + 1 - $jumlahHari - $hitungLibur" : "14"}, " // total_hari
            "sisa_cuti = ${jenisCuti != "CR" ? "$sisaCuti" : "0"}, " // sisa_cuti
            "tgl_end = ${jenisCuti != "CR" ? "'${StringUtils.midnightDate(tglAkhirInDateTime)}'" : "'${StringUtils.midnightDate(tglAwalInDateTime.add(Duration(days: 13)))}'"}, " // tgl_end
            "tgl_end_hrd = ${jenisCuti != "CR" ? "'${StringUtils.midnightDate(tglAkhirInDateTime)}'" : "'${StringUtils.midnightDate(tglAwalInDateTime.add(Duration(days: 13)))}'"}, " // tgl_end_hrd
            "tgl_start = '${StringUtils.midnightDate(tglAwalInDateTime)}', " // tgl_start
            "tgl_start_hrd = '${StringUtils.midnightDate(tglAwalInDateTime)}', " // tgl_start_hrd
            "u_date = GETDATE(), " // u_date
            "u_user = '$nama' WHERE id_cuti = $idCuti", // u_user
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateCuti);

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

  Future<Unit> submitCuti({
    required String jenisCuti,
    required String alasan,
    required String ket,
    required String tahunCuti,
    //
    required int idUser,
    required int sisaCuti,
    //
    required int jumlahHari,
    required int hitungLibur,
    // date time
    required DateTime tglAwalInDateTime,
    required DateTime tglAkhirInDateTime,
  }) async {
    try {
      final Map<String, String> submitCuti = {
        "command": "INSERT INTO $dbCutiNew ("
            "id_cuti, id_user, IdKary, jenis_cuti, alasan, ket, bulan_cuti, tahun_cuti, "
            "total_hari, sisa_cuti, tgl_end, tgl_end_hrd, tgl_start, tgl_start_hrd, spv_tgl, hrd_tgl, "
            "c_date, c_user, u_date, u_user ) VALUES ("
            "(Select isnull(max(id_cuti),0) + 1 from $dbCutiNew), " // id_cuti
            "$idUser, " // id_user
            "(select IdKary from $dbMstUser where id_user = $idUser), " // IdKary
            "'$jenisCuti', " // jenis_cuti
            "'$alasan', " // alasan
            "'$ket', " // ket
            "DATENAME(MONTH, '${tglAwalInDateTime.toString()}'), " // bulan_cuti
            "'$tahunCuti', " // tahun_cuti
            "${jenisCuti != "CR" ? "DATEDIFF(DAY, '${tglAwalInDateTime.toString()}', '${tglAkhirInDateTime.toString()}') + 1 - $jumlahHari - $hitungLibur, " : "14, "}" // total_hari
            "${jenisCuti != "CR" ? "$sisaCuti," : "0,"}" // sisa_cuti
            "${jenisCuti != "CR" ? "'${StringUtils.midnightDate(tglAkhirInDateTime)}'," : "'${StringUtils.midnightDate(tglAwalInDateTime.add(Duration(days: 13)))}',"}" // tgl_end
            "${jenisCuti != "CR" ? "'${StringUtils.midnightDate(tglAkhirInDateTime)}'," : "'${StringUtils.midnightDate(tglAwalInDateTime.add(Duration(days: 13)))}',"}" // tgl_end_hrd
            "'${StringUtils.midnightDate(tglAwalInDateTime)}', " // tgl_start
            "'${StringUtils.midnightDate(tglAwalInDateTime)}', " // tgl_start_hrd
            "GETDATE(), " // spv_tgl
            "GETDATE(), " // hrd_tgl
            "GETDATE(), " // c_date
            "'0', " // c_user
            "GETDATE(), " // u_date
            "'0')", // u_user
        "mode": "INSERT"
      };

      final data = _dioRequest;
      data.addAll(submitCuti);

      debugger();

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      debugger();

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

  Future<Unit> resetCutiTahunMasuk({
    required int idUser,
    required String nama,
    required String masuk,
  }) async {
    try {
      final Map<String, String> updateCuti = {
        "command": "UPDATE $dbMstCutiNew SET "
            "cuti_baru = 0, "
            "open_date = '${DateTime.parse(masuk).year}-01-01', "
            "close_date = '${DateTime.parse(masuk).year + 1}-01-01', "
            "u_date = GETDATE(), " // u_date
            "u_user = '$nama' WHERE id_user = $idUser", // u_user
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateCuti);

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

  Future<Unit> resetCutiSatuTahunLebih({
    required int idUser,
    required String nama,
    required String masuk,
  }) async {
    try {
      final Map<String, String> updateCuti = {
        "command": "UPDATE $dbMstCutiNew SET "
            "cuti_tidak_baru = 12, "
            "tahun_cuti_tidak_baru = '${DateTime.parse(masuk).year + 2}', "
            "open_date = '${DateTime.parse(masuk).year + 2}-01-01', "
            "close_date = '${DateTime.parse(masuk).year + 1}-01-01', "
            "u_date = GETDATE(), " // u_date
            "u_user = '$nama' WHERE id_user = $idUser", // u_user
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateCuti);

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

  Future<Unit> resetCutiDuaTahunLebih({
    required int idUser,
    required String nama,
    required String masuk,
  }) async {
    try {
      final Map<String, String> updateCuti = {
        "command": "UPDATE $dbMstCutiNew SET "
            "cuti_tidak_baru = 12, "
            "tahun_cuti_tidak_baru = '${DateTime.parse(masuk).year + 1}', "
            "open_date = '${DateTime.parse(masuk).year + 1}-01-01', "
            "close_date = '${DateTime.parse(masuk).year + 1}-01-01', "
            "u_date = GETDATE(), " // u_date
            "u_user = '$nama' WHERE id_user = $idUser", // u_user
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateCuti);

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
