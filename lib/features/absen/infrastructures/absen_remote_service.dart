import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../infrastructures/exceptions.dart';
import '../../riwayat_absen/application/riwayat_absen_model.dart';
import '../../user/application/user_model.dart';
import '../../../utils/string_utils.dart';

import '../application/absen_state.dart';

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
    required Map<String, dynamic> absenMap,
  }) async {
    try {
      final query = absenMap.values.fold<String>(
        "",
        (previousValue, element) => previousValue + " " + element,
      );

      _dioRequest.addAll({
        "mode": 'INSERT',
        "command": query,
      });

      await _dioHosting.post(
        '',
        data: jsonEncode(_dioRequest),
        options: Options(contentType: 'text/plain'),
      );

      final responseProd = await _dio.post(
        '',
        data: jsonEncode(_dioRequest),
        options: Options(contentType: 'text/plain'),
      );

      final itemsProd = responseProd.data?[0];

      if (itemsProd['status'] == 'Success') {
        final absenProdExist =
            itemsProd['items'] != null && itemsProd['items'] is List;

        if (absenProdExist) {
          // if (items['errornum'] != null && items['errornum'] as int != 0) {

          //   final message = items['error'] as String?;
          //   final errorCode = items['errornum'] as int;

          //   throw RestApiExceptionWithMessage(errorCode, message);
          // }
          if (itemsProd['errornum'] != null &&
              itemsProd['errornum'] as int != 0) {
            final message = itemsProd['error'] as String?;
            final errorCode = itemsProd['errornum'] as int;

            throw RestApiExceptionWithMessage(errorCode, message);
          }

          return unit;
        } else {
          // if (items['errornum'] != null && items['errornum'] as int != 0) {
          //   final message = items['error'] as String?;
          //   final errorCode = items['errornum'] as int;

          //   throw RestApiExceptionWithMessage(errorCode, message);
          // }

          final message = itemsProd['error'] as String?;
          final errorCode = itemsProd['errornum'] as int;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
      } else {
        // if (items['errornum'] != null && items['errornum'] as int != 0) {
        //

        //   final message = items['error'] as String?;
        //   final errorCode = items['errornum'] as int;

        //   throw RestApiExceptionWithMessage(errorCode, message);
        // }

        final message = itemsProd['error'] as String?;
        final errorCode = itemsProd['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
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
      final Map<String, dynamic> data = {};
      data.addAll(_dioRequest);

      final String currentDate = StringUtils.midnightDate(date);
      final String currentDateRange =
          StringUtils.midnightDate(DateTime.now().add(Duration(days: 1)));

      data.addAll({
        "mode": "SELECT",
        "command": " with contoh as (select format(tgljam,'yyyy-MM-dd') as tgl, "
            " id_user from $dbNameProd where id_user = ${_userModelWithPassword.idUser} "
            " and tgljam >= '$currentDate' and tgljam < '$currentDateRange' group by "
            "  format(tgljam,'yyyy-MM-dd'), id_user) select *, (select max(lokasi_masuk) "
            " from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' and "
            " format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as lokasi_masuk, (select max(latitude_masuk) "
            " from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' and "
            " format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as latitude_masuk, "
            " (select max(longitude_masuk) from $dbNameProd where id_user = contoh.id_user "
            " and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as longitude_masuk, "
            " (select min(tgljam) from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' "
            " and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as masuk, (select max(lokasi_keluar) "
            " from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' and "
            " format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as lokasi_keluar, "
            " (select max(latitude_keluar) from $dbNameProd where id_user =  "
            "  contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = "
            " contoh.tgl) as latitude_keluar, (select max(longitude_keluar) from "
            " $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' and "
            " format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as longitude_keluar, "
            " (select max(tgljam) from $dbNameProd where id_user = contoh.id_user and "
            " mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as pulang from contoh",
      });

      final response = await _dio.post(
        '',
        data: jsonEncode(data),
        options: Options(contentType: 'text/plain'),
      );

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final absenExist = items['items'] != null && items['items'] is List;

        if (absenExist) {
          final list = items['items'] as List<dynamic>;

          if (list.isEmpty) {
            return AbsenState.empty();
          }

          final map = list[0] as Map<String, dynamic>;

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
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<List<RiwayatAbsenModel>> getRiwayatAbsen({
    required String? dateFirst,
    required String? dateSecond,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      data.addAll(_dioRequest);

      data.addAll({
        "mode": "SELECT",
        "command": "with contoh as (select format(tgljam,'yyyy-MM-dd') as tgl, id_user from $dbNameProd "
            " where id_user = ${_userModelWithPassword.idUser} and tgljam >= '$dateSecond' and tgljam < '$dateFirst' "
            " group by format(tgljam,'yyyy-MM-dd'), id_user) select *, (select max(lokasi_masuk) from $dbNameProd "
            " where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as  "
            " lokasi_masuk, (select max(latitude_masuk) from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' and  "
            " format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as latitude_masuk, (select max(longitude_masuk) from $dbNameProd "
            " where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as longitude_masuk, "
            " (select min(tgljam) from $dbNameProd where id_user = contoh.id_user and mode = 'MASUK' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) "
            " as masuk, "
            " (select max(lokasi_keluar) from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) "
            " as lokasi_keluar, (select max(latitude_keluar) from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' "
            " and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as latitude_keluar, (select max(longitude_keluar) "
            " from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) "
            " as longitude_keluar, (select max(tgljam) from $dbNameProd where id_user = contoh.id_user and mode = 'PULANG' "
            " and format(tgljam, 'yyyy-MM-dd') = contoh.tgl) as pulang from contoh",
      });

      final response = await _dio.post(
        '',
        data: jsonEncode(data),
        options: Options(contentType: 'text/plain'),
      );

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final riwayatExist = items['items'] != null && items['items'] is List;

        if (riwayatExist) {
          final list = items['items'] as List;

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
          return [];
        }
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException {
      throw FormatException();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
