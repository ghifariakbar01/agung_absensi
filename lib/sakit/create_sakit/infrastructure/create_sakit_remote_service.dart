import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../../infrastructure/exceptions.dart';
import '../application/create_sakit.dart';

class CreateSakitRemoteService {
  CreateSakitRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbKaryawan = 'karyawan';
  static const String dbMstLibur = 'mst_libur';
  static const String dbHrSakit = 'hr_trs_sakit';
  static const String dbMstCutiNew = 'hr_mst_cuti_new';

  Future<Unit> submitSakit({
    required int idUser,
    required String ket,
    required String surat,
    required String cUser,
    required String tglEnd,
    required String tglStart,
    required int jumlahHari,
    required int hitungLibur,
  }) async {
    try {
      final Map<String, String> submitSakit = {
        "command": "INSERT INTO $dbHrSakit ("
            "id_user, ket, tgl_start, tgl_end, surat, tot_hari, periode, "
            "spv_sta, spv_nm, spv_tgl, hrd_sta, hrd_nm, hrd_tgl, "
            "c_date, c_user, u_date, u_user) VALUES ("
            "$idUser, "
            "'$ket', "
            "'$tglStart', "
            "'$tglEnd', "
            "'$surat', "
            "((datediff(day,'$tglStart', '$tglEnd') + 1) - $jumlahHari) - $hitungLibur, "
            "(DATENAME(MONTH,'$tglStart')), "
            "'0', "
            "'', "
            "getdate(), "
            "'0', "
            "'', "
            "getdate(), "
            "getdate(), "
            "'$cUser', "
            "getdate(), "
            "'$cUser') ",
        "mode": "INSERT"
      };

      final data = _dioRequest;
      data.addAll(submitSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      debugger();
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

  Future<int> getLastSubmitSakit({
    required int idUser,
  }) async {
    try {
      final Map<String, String> submitSakit = {
        "command": " SELECT TOP 1 * FROM "
            " $dbHrSakit WHERE id_user = $idUser ORDER BY c_date DESC ",
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
        final listExist = items['items'] != null && items['items'] is List;

        if (listExist) {
          if (items['items'][0]['id_sakit'] != null) {
            final idSakit = items['items'][0]['id_sakit'] as int;
            return idSakit;
          }

          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

          throw RestApiExceptionWithMessage(errorCode, message);
        } else {
          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

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

  Future<Unit> updateSakit({
    required int id,
    required int idUser,
    required String ket,
    required String surat,
    required String uUser,
    required String tglEnd,
    required String tglStart,
    required int jumlahHari,
    required int hitungLibur,
  }) async {
    try {
      // add spv / hrd note
      final Map<String, String> submitSakit = {
        "command": "UPDATE $dbHrSakit SET "
            " id_user = $idUser,  "
            " ket = '$ket',  "
            " surat = '$surat',  "
            " tot_hari = ((datediff(day,'$tglStart', '$tglEnd') + 1) - $jumlahHari) - $hitungLibur,  "
            " periode = (DATENAME(MONTH,'$tglStart')),  "
            " tgl_start = '$tglStart',  "
            " tgl_end = '$tglEnd',  "
            " spv_note = '',  "
            " hrd_note = '',  "
            " u_date = getdate(), "
            " u_user = '$uUser' "
            " WHERE id_sakit = $id ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(submitSakit);

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

  Future<CreateSakit> getCreateSakit({
    required int idUser,
    required String tglAwal,
    required String tglAkhir,
  }) async {
    String? masuk;
    int hitunglibur = 0;
    String jdwSabtu = "";
    bool bulanan = false;

    // 1. GET HITUNG LIBUR, BETWEEN DATES
    try {
      final Map<String, String> selectHitungLibur = {
        'command': " SELECT COUNT(id_libur) AS hitunglibur " +
            " FROM $dbMstLibur " +
            " WHERE jenis <> 'LIBUR' AND tgl_awal BETWEEN '$tglAwal' AND '$tglAkhir' ",
        'mode': 'SELECT'
      };

      final dataSelectHitungLibur = _dioRequest;
      dataSelectHitungLibur.addAll(selectHitungLibur);

      final response2 = await _dio.post('',
          data: jsonEncode(dataSelectHitungLibur),
          options: Options(contentType: 'text/plain'));

      log('tglAwal $tglAwal tglAkhir $tglAkhir : response $response2');

      final items2 = response2.data?[0];

      if (items2['status'] == 'Success') {
        final listExist = items2['items'] != null && items2['items'] is List;

        if (listExist) {
          if (items2['items'][0]['hitunglibur'] != null) {
            items2['items'][0]['hitunglibur'] = hitunglibur;
          }
        }
      } else {
        final message = items2['error'] as String?;
        final errorCode = items2['errornum'] as int;

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

    // 2. GET DATE MASUK, BY ID KARYAWAN
    try {
      final Map<String, String> selectMasterKaryawan = {
        'command':
            " SELECT * FROM $dbKaryawan WHERE idKary = (SELECT IdKary FROM mst_user WHERE id_user = $idUser)  ",
        'mode': 'SELECT'
      };

      final dataSelectMasterKaryawan = _dioRequest;
      dataSelectMasterKaryawan.addAll(selectMasterKaryawan);

      final response3 = await _dio.post('',
          data: jsonEncode(dataSelectMasterKaryawan),
          options: Options(contentType: 'text/plain'));

      final items3 = response3.data?[0];

      if (items3['status'] == 'Success') {
        final listExist = items3['items'] != null && items3['items'] is List;

        if (listExist) {
          if (items3['items'][0]['Masuk'] != null) {
            masuk = items3['items'][0]['Masuk'];
          } else {
            throw RestApiExceptionWithMessage(404, 'items Masuk Karyawan null');
          }
        }
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

    final createSakit = CreateSakit(
      masuk: masuk,
      bulanan: bulanan,
      jadwalSabtu: jdwSabtu,
      hitungLibur: hitunglibur,
    );

    log('createSakit $createSakit');

    return createSakit;
  }
}
