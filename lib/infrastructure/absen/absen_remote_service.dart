import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/application/absen/absen_response.dart';
import 'package:face_net_authentication/application/absen/absen_state.dart';
import 'package:face_net_authentication/application/user/user_model.dart';
import 'package:face_net_authentication/domain/absen_failure.dart';

import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../application/absen/absen_enum.dart';
import '../../application/riwayat_absen/riwayat_absen_model.dart';
import '../../utils/string_utils.dart';
import '../exceptions.dart';

class AbsenRemoteService {
  AbsenRemoteService(
    this._dio,
    this._userModelWithPassword,
    this._dioRequest,
  );

  final Dio _dio;
  final UserModelWithPassword _userModelWithPassword;
  final Map<String, String> _dioRequest;

  static const String dbNameProd = 'hr_trs_absen';
  static const String dbName = 'hr_trs_absenmnl';

  final currentMonth = StringUtils.monthDate(DateTime.now());

  Future<Unit> absen({
    required String idAbsenMnl,
    required String lokasi,
    required String latitude,
    required String longitude,
    required JenisAbsen inOrOut,
    required String jenisAbsen,
    required DateTime date,
    required String idGeof,
    required String imei,

    // required String idUser,
    // required String tgl,
    // required String jamAwal,
    // required String jamAkhir,
    // required String keterangan,
    // required int btlSta,
    // required String cDate,
    // required String cUser,
    // required String uDate,
    // required String uUser,
    // required int spvSta,
    // required String spvTanggal,
    // required int hrdSta,
    // required String periode,
  }) async {
    final currentDate = StringUtils.midnightDate(date);
    final trimmedDate = StringUtils.trimmedDate(date);
    final ket = inOrOut == JenisAbsen.absenIn ? 'MASUK' : 'PULANG';
    final coancenate = inOrOut == JenisAbsen.absenIn ? 'masuk' : 'keluar';

    try {
      final data = _dioRequest;

      debugger(message: 'called');

      data.addAll({
        "mode": 'INSERT',
      });

      if (inOrOut == JenisAbsen.absenIn) {
        data.addAll({
          "command":
              "INSERT INTO $dbName (id_absenmnl, id_user, tgl, jam_awal, ket, c_date, hrd_tgl, c_user, u_date, u_user, spv_sta, spv_tgl, hrd_sta, btl_sta, periode, jenis_absen, latitude_$coancenate, longtitude_$coancenate, lokasi_$coancenate) VALUES ('$idAbsenMnl', '${_userModelWithPassword.idUser}', '$currentDate', '$trimmedDate', 'ABSEN MASUK', '$currentDate', '$currentDate', '${_userModelWithPassword.nama}','$trimmedDate', '${_userModelWithPassword.nama}', 0, '$trimmedDate', 0, 0, '$currentMonth', '$jenisAbsen', '$latitude', '$longitude', '$lokasi')",
        });
      }

      if (inOrOut == JenisAbsen.absenOut) {
        data.addAll({
          "command":
              "UPDATE $dbName SET latitude_keluar = '$latitude', longtitude_keluar = '$longitude', jam_akhir = '$trimmedDate', u_date = '$trimmedDate', lokasi_keluar = '$lokasi', ket = 'ABSEN MASUK DAN ABSEN PULANG' WHERE id_user = '${_userModelWithPassword.idUser}' AND tgl = '$currentDate'",
        });
      }

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      final dataProd = _dioRequest;

      debugger(message: 'called');

      dataProd.addAll({
        "mode": 'INSERT',
        "command":
            "INSERT INTO $dbNameProd (tgljam, mode, id_user, imei, id_geof, c_date, c_user, latitude_$coancenate, longitude_$coancenate, lokasi_$coancenate) VALUES ('$trimmedDate', '$ket', '${_userModelWithPassword.idUser}', '$imei', '$idGeof', '$trimmedDate', '${_userModelWithPassword.nama}', '$latitude', '$longitude', '$lokasi')",
      });

      debugger(message: 'called');

      final responseProd = await _dio.post('',
          data: jsonEncode(dataProd),
          options: Options(contentType: 'text/plain'));

      final items = response.data?[0];

      final itemsProd = responseProd.data?[0];

      log('ABSEN REMOTE: items $items');

      log('ABSEN REMOTE: itemsProd $itemsProd');

      if (items['status'] == 'Success' && itemsProd['status'] == 'Success') {
        final absenExist = items['items'] != null && items['items'] is List;

        final absenProdExist =
            itemsProd['items'] != null && itemsProd['items'] is List;

        debugger(message: 'called');

        if (absenExist || absenProdExist) {
          if (items['errornum'] != null && items['errornum'] as int != 0) {
            debugger(message: 'called');

            throw RestApiExceptionWithMessage(
              items['errornum'] as int?,
              items['error'] as String?,
            );
          } else if (itemsProd['errornum'] != null &&
              itemsProd['errornum'] as int != 0) {
            debugger(message: 'called');

            throw RestApiExceptionWithMessage(
              itemsProd['errornum'] as int?,
              itemsProd['error'] as String?,
            );
          }

          debugger(message: 'called');

          return unit;
        } else {
          if (items['errornum'] != null && items['errornum'] as int != 0) {
            throw RestApiExceptionWithMessage(
              items['errornum'] as int?,
              items['error'] as String?,
            );
          } else {
            throw RestApiExceptionWithMessage(
              itemsProd['errornum'] as int?,
              itemsProd['error'] as String?,
            );
          }
        }
      } else {
        debugger(message: 'called');

        if (items['errornum'] != null && items['errornum'] as int != 0) {
          debugger(message: 'called');

          throw RestApiExceptionWithMessage(
            items['errornum'] as int?,
            items['error'] as String?,
          );
        } else {
          debugger(message: 'called');

          throw RestApiExceptionWithMessage(
            itemsProd['errornum'] as int?,
            itemsProd['error'] as String?,
          );
        }
      }
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

  Future<int?> getAbsenID() async {
    try {
      final String command =
          "SELECT TOP 1 id_absenmnl FROM $dbName ORDER BY id_absenmnl DESC";

      final data = _dioRequest;

      data.addAll({
        "mode": "SELECT",
        "command": command,
      });

      debugger(message: 'called');

      log('data ${jsonEncode(data)}');

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final absenExist = items['items'] != null && items['items'] is List;

        if (absenExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            final item = list[0];

            return item['id_absenmnl'];
          }
          throw RestApiException(0);
        }
        throw RestApiException(1);
      }

      return null;
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

  Future<AbsenState> getAbsen({
    required DateTime date,
  }) async {
    try {
      final currentDate = StringUtils.midnightDate(date);
      final currentDateRange =
          StringUtils.midnightDate(DateTime.now().add(Duration(days: 1)));

      final String command =
          "with contoh as (select format(tgljam,'yyyy-MM-dd') as tgl, id_user, latitude_masuk, longitude_masuk, latitude_keluar, longitude_keluar, lokasi_masuk, lokasi_keluar from hr_trs_absen where id_user = ${_userModelWithPassword.idUser} and tgljam >= '$currentDate' and tgljam < '$currentDateRange' group by format(tgljam,'yyyy-MM-dd'), id_user, latitude_masuk, longitude_masuk, latitude_keluar, longitude_keluar, lokasi_masuk, lokasi_keluar )select tgl, id_user, latitude_masuk, longitude_masuk, latitude_keluar, longitude_keluar, lokasi_masuk, lokasi_keluar, (select min(tgljam) from hr_trs_absen where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as masuk, (select max(tgljam) from hr_trs_absen where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as pulang  from contoh";

      final data = _dioRequest;

      data.addAll({
        "mode": "SELECT",
        "command": command,
      });

      log('data ${jsonEncode(data)}');

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final absenExist = items['items'] != null && items['items'] is List;

        if (absenExist) {
          final list = items['items'] as List;

          log('GET ABSEN TODAY: $list');

          if (list.isNotEmpty) {
            final sudahAbsen = list.length == 2;

            final absenMasuk = list.length == 1;

            if (sudahAbsen) {
              return AbsenState.complete();
            } else if (absenMasuk) {
              return AbsenState.absenIn();
            }
          } else {
            debugger(message: 'called');

            return AbsenState.empty();
          }
        } else {
          return AbsenState.empty();
        }
      } else {
        return AbsenState.failure(
          errorCode: items['errornum'] as int?,
          message: items['error'] as String?,
        );
      }
      debugger(message: 'called');

      return AbsenState.failure(
        errorCode: items['errornum'] as int?,
        message: items['error'] as String?,
      );
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

  Future<List<RiwayatAbsenModel>> getRiwayatAbsen(
      {required int page,
      required String? dateFirst,
      required String? dateSecond}) async {
    // DATEFORMAT YYYY - MM - DD
    try {
      final String command =
          "with contoh as (select format(tgljam,'yyyy-MM-dd') as tgl, id_user from hr_trs_absen where id_user = ${_userModelWithPassword.idUser} and tgljam >= '$dateSecond' and tgljam < '$dateFirst' group by format(tgljam,'yyyy-MM-dd'), id_user) select *, (select max(lokasi_masuk) from hr_trs_absen where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as lokasi_masuk, (select max(latitude_masuk) from hr_trs_absen where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as latitude_masuk, (select max(longitude_masuk) from hr_trs_absen where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as longitude_masuk, (select min(tgljam) from hr_trs_absen where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as masuk, (select max(lokasi_keluar) from hr_trs_absen where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as lokasi_keluar, (select max(latitude_keluar) from hr_trs_absen where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as latitude_keluar, (select max(longitude_keluar) from hr_trs_absen where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as longitude_keluar, (select max(tgljam) from hr_trs_absen where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as pulang from contoh";

      final data = _dioRequest;

      data.addAll({
        "mode": "SELECT",
        "command": command,
      });

      log('data ${jsonEncode(data)}');

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final riwayatExist = items['items'] != null && items['items'] is List;

        if (riwayatExist) {
          final list = items['items'] as List;

          log('list $list');

          if (list.isNotEmpty) {
            final List<RiwayatAbsenModel> riwayatList = [];

            for (var riwayat in list) {
              riwayatList.add(
                  RiwayatAbsenModel.fromJson(riwayat as Map<String, dynamic>));
            }

            return [...riwayatList.reversed];
          }

          return [];
        } else {
          debugger(message: 'called');

          return [];
        }
      } else {
        throw RestApiException(5);
      }
    } on FormatException {
      throw FormatException();
    } on DioError catch (e) {
      if (e.isNoConnectionError || e.isConnectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        log('e.response ${e.response}');
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
