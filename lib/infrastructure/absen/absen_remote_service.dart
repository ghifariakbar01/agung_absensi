import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../application/absen/absen_enum.dart';
import '../../application/absen/absen_state.dart';
import '../../application/riwayat_absen/riwayat_absen_model.dart';
import '../../application/user/user_model.dart';
import '../../utils/string_utils.dart';
import '../exceptions.dart';

class AbsenRemoteService {
  AbsenRemoteService(
    this._dio,
    this._dioHosting,
    this._dioRequest,
    this._userModelWithPassword,
  );

  final Dio _dio;
  final Dio _dioHosting;
  final Map<String, String> _dioRequest;
  final UserModelWithPassword _userModelWithPassword;

  static const String dbNameProd = 'hr_trs_absen';

  Future<Unit> absen({
    required String lokasi,
    required String latitude,
    required String longitude,
    required String idGeof,
    required String imei,
    required DateTime date,
    required DateTime dbDate,
    required JenisAbsen inOrOut,
    // required String idAbsenMnl,
    // required String jenisAbsen,
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
    // final currentMonth = StringUtils.monthDate(dbDate);
    // //
    // final currentDate = StringUtils.midnightDate(date);
    final trimmedDate = StringUtils.trimmedDate(date);
    //
    final trimmedDateDb = StringUtils.trimmedDate(dbDate);
    //
    final ket = inOrOut == JenisAbsen.absenIn ? 'MASUK' : 'PULANG';
    final coancenate = inOrOut == JenisAbsen.absenIn ? 'masuk' : 'keluar';

    try {
      final data = _dioRequest;

      data.addAll({
        "mode": 'INSERT',
        "command": "INSERT INTO $dbNameProd " +
            "(tgljam, mode, id_user, imei, id_geof, c_date, c_user, latitude_$coancenate, longitude_$coancenate, lokasi_$coancenate)" +
            " VALUES " +
            "('$trimmedDate', '$ket', '${_userModelWithPassword.idUser}', '$imei', '$idGeof', '$trimmedDateDb', '${_userModelWithPassword.nama}', '$latitude', '$longitude', '$lokasi')",
      });

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      final response2 = await _dioHosting.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      final items = response.data?[0];
      final isSuccess = items['status'] == 'Success';

      final items2 = response2.data?[0];
      final isSuccess2 = items2['status'] == 'Success';

      if (isSuccess2 != isSuccess) {
        final message = 'Error server hosting / original';
        final errorCode = 404;

        throw RestApiExceptionWithMessage(errorCode, message);
      }

      // log('ABSEN REMOTE: items $items');

      log('ABSEN REMOTE: items $items');

      if (items['status'] == 'Success') {
        // final absenExist = items['items'] != null && items['items'] is List;

        debugger(message: 'called');

        if (items['items'] != null && items['items'] is List) {
          // if (items['errornum'] != null && items['errornum'] as int != 0) {
          //   debugger(message: 'called');
          //   final message = items['error'] as String?;
          //   final errorCode = items['errornum'] as int;

          //   throw RestApiExceptionWithMessage(errorCode, message);
          // }
          if (items['errornum'] != null && items['errornum'] as int != 0) {
            debugger(message: 'called');

            final message = items['error'] as String?;
            final errorCode = items['errornum'] as int;

            throw RestApiExceptionWithMessage(errorCode, message);
          }

          debugger(message: 'called');

          return unit;
        } else {
          // if (items['errornum'] != null && items['errornum'] as int != 0) {
          //   final message = items['error'] as String?;
          //   final errorCode = items['errornum'] as int;

          //   throw RestApiExceptionWithMessage(errorCode, message);
          // }

          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
      } else {
        debugger(message: 'called');

        // if (items['errornum'] != null && items['errornum'] as int != 0) {
        //   debugger(message: 'called');

        //   final message = items['error'] as String?;
        //   final errorCode = items['errornum'] as int;

        //   throw RestApiExceptionWithMessage(errorCode, message);
        // }

        debugger(message: 'called');

        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
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

  // Future<int?> getAbsenID() async {
  //   try {
  //     final String command =
  //         "SELECT TOP 1 id_absenmnl FROM $dbName ORDER BY id_absenmnl DESC";

  //     final data = _dioRequest;

  //     data.addAll({
  //       "mode": "SELECT",
  //       "command": command,
  //     });

  //     debugger(message: 'called');

  //     log('data ${jsonEncode(data)}');

  //     final response = await _dio.post('',
  //         data: jsonEncode(data), options: Options(contentType: 'text/plain'));

  //     final items = response.data?[0];

  //     if (items['status'] == 'Success') {
  //       final absenExist = items['items'] != null && items['items'] is List;

  //       if (absenExist) {
  //         final list = items['items'] as List;

  //         if (list.isNotEmpty) {
  //           final item = list[0];

  //           return item['id_absenmnl'];
  //         } else {
  //           final message = items['error'] as String?;
  //           final errorCode = items['errornum'] as int;

  //           throw RestApiExceptionWithMessage(errorCode, message);
  //         }
  //       }
  //     } else {
  //       final message = items['error'] as String?;
  //       final errorCode = items['errornum'] as int;

  //       throw RestApiExceptionWithMessage(errorCode, message);
  //     }

  //     return null;
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

  Future<AbsenState> getAbsen({
    required DateTime date,
  }) async {
    try {
      final currentDate = StringUtils.midnightDate(date);
      final currentDateRange =
          StringUtils.midnightDate(DateTime.now().add(Duration(days: 1)));

      final String command =
          "with contoh as (select format(tgljam,'yyyy-MM-dd') as tgl, id_user from $dbNameProd where id_user = ${_userModelWithPassword.idUser} and tgljam >= '$currentDate' and tgljam < '$currentDateRange' group by format(tgljam,'yyyy-MM-dd'), id_user) select *, (select max(lokasi_masuk) from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as lokasi_masuk, (select max(latitude_masuk) from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as latitude_masuk, (select max(longitude_masuk) from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as longitude_masuk, (select min(tgljam) from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as masuk, (select max(lokasi_keluar) from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as lokasi_keluar, (select max(latitude_keluar) from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as latitude_keluar, (select max(longitude_keluar) from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as longitude_keluar, (select max(tgljam) from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as pulang from contoh";

      final data = _dioRequest;

      // debugger();

      data.addAll({
        "mode": "SELECT",
        "command": command,
      });

      // debugger();

      log('data ${jsonEncode(data)}');

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final absenExist = items['items'] != null && items['items'] is List;

        if (absenExist) {
          final list = items['items'] as List<dynamic>;

          log('GET ABSEN TODAY LIST: $list');

          if (list.isEmpty) {
            return AbsenState.empty();
          }

          final map = list[0] as Map<String, dynamic>;

          log('GET ABSEN TODAY MAP: $map');

          if (map.isNotEmpty) {
            final sudahAbsen = map['pulang'] != null;

            final absenMasuk = map['masuk'] != null;

            if (sudahAbsen) {
              return AbsenState.complete();
            } else if (absenMasuk) {
              return AbsenState.absenIn();
            }
          } else {
            return AbsenState.empty();
          }
        } else {
          // debugger();

          return AbsenState.empty();
        }
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
      final message = items['error'] as String?;
      final errorCode = items['errornum'] as int;

      throw RestApiExceptionWithMessage(errorCode, message);
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
          "with contoh as (select format(tgljam,'yyyy-MM-dd') as tgl, id_user from $dbNameProd where id_user = ${_userModelWithPassword.idUser} and tgljam >= '$dateSecond' and tgljam < '$dateFirst' group by format(tgljam,'yyyy-MM-dd'), id_user) select *, (select max(lokasi_masuk) from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as lokasi_masuk, (select max(latitude_masuk) from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as latitude_masuk, (select max(longitude_masuk) from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as longitude_masuk, (select min(tgljam) from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as masuk, (select max(lokasi_keluar) from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as lokasi_keluar, (select max(latitude_keluar) from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as latitude_keluar, (select max(longitude_keluar) from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as longitude_keluar, (select max(tgljam) from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as pulang from contoh";

      final data = _dioRequest;

      data.addAll({
        "mode": "SELECT",
        "command": command,
      });

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data baseUrl ${_dio.options.baseUrl}');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final riwayatExist = items['items'] != null && items['items'] is List;

        if (riwayatExist) {
          final list = items['items'] as List;

          // log('list $list');

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
        // debugger();

        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
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
