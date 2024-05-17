import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';

import '../../../infrastructures/exceptions.dart';
import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../cuti_list/application/cuti_list.dart';

class CutiApproveRemoteService {
  CutiApproveRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_cuti_new';
  static const String dbMstCutiNew = 'hr_mst_cuti_new';
  //

  Future<Unit> approveSpv(
      {required int idCuti, required String nama, required String note}) async {
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbName SET "
                " spv_nm = '$nama', " +
            " spv_sta = 1, " +
            " spv_tgl = getdate(), " +
            " spv_note = '$note' " +
            " WHERE id_cuti = $idCuti ",
        "mode": "UPDATE"
      };

      // debugger();

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

  Future<Unit> unapproveSpv({required int idCuti, required String nama}) async {
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbName SET "
                " spv_nm = '$nama', " +
            " spv_sta = 0, " +
            " spv_tgl = GETDATE() " +
            " WHERE id_cuti = $idCuti ",
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

  Future<Unit> approveHrd({
    required String nama,
    required String note,
    required CutiList itemCuti,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbName SET "
                " hrd_nm = '$nama', " +
            " hrd_sta = 1, " +
            " hrd_tgl = getdate(), " +
            " hrd_note = '$note' " +
            " WHERE id_cuti = ${itemCuti.idCuti} ",
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

  Future<Unit> unapproveHrd({
    required String nama,
    required CutiList itemCuti,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbName SET "
                " hrd_nm = '$nama', " +
            " hrd_sta = 0, " +
            " hrd_tgl = getdate() " +
            " WHERE id_cuti = ${itemCuti.idCuti} ",
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

  Future<Unit> calcSisaCuti(
      {required CutiList itemCuti, bool isRestore = false}) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbName SET "
            " ${isRestore ? " sisa_cuti = '${itemCuti.sisaCuti! + itemCuti.totalHari!}' " : " sisa_cuti = '${itemCuti.sisaCuti! - itemCuti.totalHari!}' "} "
            " WHERE id_cuti = ${itemCuti.idCuti} ",
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

  Future<Unit> calcCutiTidakBaru(
      {required int totalHari,
      required MstKaryawanCuti mstCuti,
      bool isRestore = false}) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbMstCutiNew SET "
            " ${isRestore ? " cuti_tidak_baru = '${mstCuti.cutiTidakBaru! + totalHari}' " : " cuti_tidak_baru = '${mstCuti.cutiTidakBaru! - totalHari}' "} "
            " WHERE id_mst_cuti = ${mstCuti.idMstCuti} ",
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

  Future<Unit> calcCutiBaru(
      {required int totalHari,
      required MstKaryawanCuti mstCuti,
      bool isRestore = false}) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbMstCutiNew SET "
            " ${isRestore ? " cuti_baru = '${mstCuti.cutiBaru! + totalHari}' " : " cuti_baru = '${mstCuti.cutiBaru! - totalHari}' "} "
            " WHERE id_mst_cuti = ${mstCuti.idMstCuti} ",
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

  Future<Unit> calcCloseOpenDate({
    required String masuk,
    required MstKaryawanCuti mstCuti,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbMstCutiNew SET "
                " close_date = '${DateTime.parse(masuk).year}-01-01', " +
            " open_date = '${DateTime.parse(masuk).year + 1}-01-01' " +
            " WHERE id_mst_cuti = ${mstCuti.idMstCuti} ",
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

  Future<Unit> calcCloseOpenCutiTidakBaruDanTahuCuti({
    required String masuk,
    required MstKaryawanCuti mstCuti,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbMstCutiNew SET "
                " cuti_tidak_baru = 12, " +
            " tahun_cuti_tidak_baru = '${DateTime.parse(masuk).year + 2}', " +
            " close_date = '${DateTime.parse(masuk).year + 1}-01-01', " +
            " open_date = '${DateTime.parse(masuk).year + 2}-01-01' " +
            " WHERE id_mst_cuti = ${mstCuti.idMstCuti} ",
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

  Future<Unit> calcCloseOpenCutiTidakBaruDanTahuCuti2({
    required MstKaryawanCuti mstCuti,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbMstCutiNew SET "
                " cuti_tidak_baru = 12, " +
            " tahun_cuti_tidak_baru = '${mstCuti.openDate!.year + 1}', " +
            " open_date = '${mstCuti.openDate!.year + 1}-01-01', " +
            " ${mstCuti.openDate == mstCuti.closeDate ? " close_date = ${mstCuti.closeDate!.year}-01-01 " : " close_date = ${mstCuti.closeDate!.year + 1}-01-01 "} " +
            " WHERE id_mst_cuti = ${mstCuti.idMstCuti} ",
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

  Future<Unit> batal({
    required String nama,
    required CutiList itemCuti,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbName SET "
                " btl_nm = '$nama', " +
            " btl_sta = 1, " +
            " btl_tgl = getdate() " +
            " WHERE id_cuti = ${itemCuti.idCuti} ",
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
