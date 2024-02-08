import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../../infrastructure/exceptions.dart';
import '../../cuti_list/application/cuti_list.dart';

class CutiApproveRemoteService {
  CutiApproveRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_sakit';
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
            " hrd_note = '$note', " +
            " sisa_cuti = ${itemCuti.sisaCuti! - itemCuti.totalHari!} " +
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

  // Future<Unit> unApproveHrdTanpaSurat({
  //   required String nama,
  //   required SakitList itemSakit,
  //   required CreateSakit createSakit,
  // }) async {
  //   // 1. UPDATE SAKIT
  //   try {
  //     int? cutiTidakBaruNew;
  //     int? cutiBaruNew;
  //     DateTime masuk = DateTime.parse(createSakit.masuk!);

  //     if (masuk.year != createSakit.createSakitCuti!.openDate!.year) {
  //       cutiTidakBaruNew =
  //           createSakit.createSakitCuti!.cutiTidakBaru! + itemSakit.totHari!;
  //     } else {
  //       cutiBaruNew =
  //           createSakit.createSakitCuti!.cutiBaru! + itemSakit.totHari!;
  //     }

  //     final Map<String, String> updateSakit = {
  //       "command": "UPDATE $dbName SET "
  //               " hrd_nm = '$nama', " +
  //           " hrd_sta = 0, " +
  //           " hrd_tgl = getdate() " +
  //           " WHERE id_cuti = ${itemSakit.idCuti} "
  //               //
  //               " UPDATE $dbMstCutiNew SET "
  //               " ${cutiTidakBaruNew != null ? " cuti_tidak_baru = $cutiTidakBaruNew " : ""} " +
  //           " ${cutiBaruNew != null ? " cuti_baru = $cutiBaruNew " : ""} " +
  //           " WHERE FORMAT(open_date, 'yyyy-01-01') = '${createSakit.createSakitCuti!.openDate!.year}-01-01' "
  //               " AND id_user = ${itemSakit.idUser} ",
  //       "mode": "UPDATE"
  //     };

  //     final data = _dioRequest;
  //     data.addAll(updateSakit);

  //     final response = await _dio.post('',
  //         data: jsonEncode(data), options: Options(contentType: 'text/plain'));

  //     log('data ${jsonEncode(data)}');
  //     log('response $response');
  //     final items = response.data?[0];

  //     if (items['status'] == 'Success') {
  //       return unit;
  //     } else {
  //       final message = items['error'] as String?;
  //       final errorCode = items['errornum'] as int;

  //       throw RestApiExceptionWithMessage(errorCode, message);
  //     }
  //   } on FormatException catch (e) {
  //     throw FormatException(e.message);
  //   } on DioError catch (e) {
  //     if (e.isNoConnectionError || e.isConnectionTimeout) {
  //       throw NoConnectionException();
  //     } else if (e.response != null) {
  //       throw RestApiException(e.response?.statusCode);
  //     } else {
  //       rethrow;
  //     }
  //   }
  // }

  // Future<Unit> unApproveSpv({
  //   required String nama,
  //   required SakitList itemSakit,
  // }) async {
  //   // 1. UPDATE SAKIT
  //   try {
  //     final Map<String, String> updateSakit = {
  //       "command": "UPDATE $dbName SET "
  //               " spv_nm = '$nama', " +
  //           " spv_sta = 0, " +
  //           " spv_tgl = getdate() " +
  //           " WHERE id_cuti = ${itemSakit.idCuti} ",
  //       "mode": "UPDATE"
  //     };

  //     final data = _dioRequest;
  //     data.addAll(updateSakit);

  //     final response = await _dio.post('',
  //         data: jsonEncode(data), options: Options(contentType: 'text/plain'));

  //     log('data ${jsonEncode(data)}');
  //     log('response $response');
  //     final items = response.data?[0];

  //     if (items['status'] == 'Success') {
  //       return unit;
  //     } else {
  //       final message = items['error'] as String?;
  //       final errorCode = items['errornum'] as int;

  //       throw RestApiExceptionWithMessage(errorCode, message);
  //     }
  //   } on FormatException catch (e) {
  //     throw FormatException(e.message);
  //   } on DioError catch (e) {
  //     if (e.isNoConnectionError || e.isConnectionTimeout) {
  //       throw NoConnectionException();
  //     } else if (e.response != null) {
  //       throw RestApiException(e.response?.statusCode);
  //     } else {
  //       rethrow;
  //     }
  //   }
  // }

  // Future<Unit> batal({
  //   required String nama,
  //   required SakitList itemSakit,
  // }) async {
  //   // 1. UPDATE SAKIT
  //   try {
  //     final Map<String, String> updateSakit = {
  //       "command": "UPDATE $dbName SET "
  //               " btl_nm = '$nama', " +
  //           " btl_sta = 1, " +
  //           " btl_tgl = getdate() " +
  //           " WHERE id_cuti = ${itemSakit.idCuti} ",
  //       "mode": "UPDATE"
  //     };

  //     final data = _dioRequest;
  //     data.addAll(updateSakit);

  //     final response = await _dio.post('',
  //         data: jsonEncode(data), options: Options(contentType: 'text/plain'));

  //     log('data ${jsonEncode(data)}');
  //     log('response $response');
  //     final items = response.data?[0];

  //     if (items['status'] == 'Success') {
  //       return unit;
  //     } else {
  //       final message = items['error'] as String?;
  //       final errorCode = items['errornum'] as int;

  //       throw RestApiExceptionWithMessage(errorCode, message);
  //     }
  //   } on FormatException catch (e) {
  //     throw FormatException(e.message);
  //   } on DioError catch (e) {
  //     if (e.isNoConnectionError || e.isConnectionTimeout) {
  //       throw NoConnectionException();
  //     } else if (e.response != null) {
  //       throw RestApiException(e.response?.statusCode);
  //     } else {
  //       rethrow;
  //     }
  //   }
  // }
}
