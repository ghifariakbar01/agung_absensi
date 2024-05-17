import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';

import '../../../infrastructures/exceptions.dart';

class TugasDinasApproveRemoteService {
  TugasDinasApproveRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_dinas';

  //

  Future<Unit> approveSpv({required int idDinas, required String nama}) async {
    try {
      final Map<String, String> updateDinas = {
        "command": "UPDATE $dbName SET "
                " spv_nm = '$nama', " +
            " spv_sta = 1, " +
            " spv_tgl = getdate() " +
            " WHERE id_dinas = $idDinas ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateDinas);

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

  Future<Unit> unApproveSpv({
    required int idDinas,
    required String nama,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateDinas = {
        "command": "UPDATE $dbName SET "
                " spv_nm = '$nama', " +
            " spv_sta = 0, " +
            " spv_tgl = getdate() " +
            " WHERE id_dinas = $idDinas ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateDinas);

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

  Future<Unit> approveGm({
    required int idDinas,
    required String namaGm,
  }) async {
    try {
      final Map<String, String> updateDinas = {
        "command": "UPDATE $dbName SET "
                " gm_nm = '$namaGm', " +
            " gm_sta = 1, " +
            " gm_tgl = getdate() " +
            " WHERE id_dinas = $idDinas ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateDinas);

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

  Future<Unit> unApproveGm({
    required int idDinas,
    required String namaGm,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateDinas = {
        "command": "UPDATE $dbName SET "
                " gm_nm = '$namaGm', " +
            " gm_sta = 0, " +
            " gm_tgl = getdate() " +
            " WHERE id_dinas = $idDinas ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateDinas);

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
    required int idDinas,
    required String namaHrd,
  }) async {
    try {
      final Map<String, String> updateDinas = {
        "command": "UPDATE $dbName SET "
                " hrd_nm = '$namaHrd', " +
            " hrd_sta = 1, " +
            " hrd_tgl = getdate(), " +
            " coo_nm = 'Approved By System', " +
            " coo_sta = 1, " +
            " coo_tgl = getdate(), " +
            " gm_nm = 'Approved By System', " +
            " gm_sta = 1, " +
            " gm_tgl = getdate() " +
            " WHERE id_dinas = $idDinas ",
        "mode": "UPDATE"
      };

      // debugger();

      final data = _dioRequest;
      data.addAll(updateDinas);

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
    required int idDinas,
    required String namaHrd,
  }) async {
    try {
      final Map<String, String> updateDinas = {
        "command": "UPDATE $dbName SET "
                " hrd_nm = '$namaHrd', " +
            " hrd_sta = 0, " +
            " hrd_tgl = getdate(), " +
            " coo_nm = 'Un-Approved By System', " +
            " coo_sta = 0, " +
            " coo_tgl = getdate(), " +
            " gm_nm = 'Un-Approved By System', " +
            " gm_sta = 0, " +
            " gm_tgl = getdate() " +
            " WHERE id_dinas = $idDinas ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateDinas);

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

  Future<Unit> approveCOO({
    required int idDinas,
    required String namaCoo,
  }) async {
    try {
      final Map<String, String> updateDinas = {
        "command": "UPDATE $dbName SET "
                " coo_nm = '$namaCoo', " +
            " coo_sta = 1, " +
            " coo_tgl = getdate() " +
            " WHERE id_dinas = $idDinas ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateDinas);

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

  Future<Unit> unApproveCOO({
    required int idDinas,
    required String namaCoo,
  }) async {
    try {
      final Map<String, String> updateDinas = {
        "command": "UPDATE $dbName SET "
                " coo_nm = '$namaCoo', " +
            " coo_sta = 0, " +
            " coo_tgl = getdate() " +
            " WHERE id_dinas = $idDinas ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateDinas);

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

  Future<Unit> approveHrdLK({
    required int idDinas,
    required String namaHrd,
  }) async {
    try {
      final Map<String, String> updateDinas = {
        "command": "UPDATE $dbName SET "
                " hrd_nm = '$namaHrd', " +
            " hrd_sta = 1, " +
            " hrd_tgl = getdate() " +
            " WHERE id_dinas = $idDinas ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateDinas);

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

  Future<Unit> unApproveHrdLk({
    required int idDinas,
    required String nama,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateDinas = {
        "command": "UPDATE $dbName SET "
                " hrd_nm = '$nama', " +
            " hrd_sta = 0, " +
            " hrd_tgl = getdate() " +
            " WHERE id_dinas = $idDinas ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateDinas);

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
    required int idDinas,
    required String nama,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateDinas = {
        "command": "UPDATE $dbName SET "
                " btl_nm = '$nama', " +
            " btl_sta = 1, " +
            " btl_tgl = getdate() " +
            " WHERE id_dinas = $idDinas ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateDinas);

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
