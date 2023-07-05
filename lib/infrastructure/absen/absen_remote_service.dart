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

  static const String dbName = 'hr_trs_absenmnl_test';
  final currentDate =
      StringUtils.midnightDate(DateTime.now().subtract(Duration(days: 1)));
  final currentMonth = StringUtils.monthDate(DateTime.now());
  final trimmedNow = StringUtils.trimmedDate(DateTime.now());

  Future<Either<AbsenFailure, Unit>> absen({
    required String idAbsenMnl,
    required String lokasi,
    required String latitude,
    required String longitude,
    required JenisAbsen inOrOut,
    required String jenisAbsen,

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
    String command = '';
    String mode = '';

    try {
      if (inOrOut == JenisAbsen.absenIn) {
        mode = 'INSERT';
        command =
            "INSERT INTO $dbName (id_absenmnl, id_user, tgl, jam_awal, jam_akhir, ket, c_date, c_user, u_date, u_user, spv_sta, spv_tgl, hrd_sta, btl_sta, periode, jenis_absen, latitude_masuk, longtitude_masuk, lokasi_masuk) VALUES ('$idAbsenMnl', '${_userModelWithPassword.idUser}', '$currentDate', '$trimmedNow', '$trimmedNow', 'ABSEN MASUK', '$currentDate', '${_userModelWithPassword.nama}','$trimmedNow', '${_userModelWithPassword.nama}', 0, '$trimmedNow', 0, 0, '$currentMonth', '$jenisAbsen', '$latitude', '$longitude', '$lokasi')";
      } else if (inOrOut == JenisAbsen.absenOut) {
        mode = 'UPDATE';
        command =
            "UPDATE $dbName SET latitude_keluar = '$latitude', longtitude_keluar = '$longitude', jam_akhir = '$trimmedNow', u_date = '$trimmedNow', lokasi_keluar = '$lokasi', ket = 'ABSEN MASUK DAN ABSEN PULANG' WHERE id_user = '${_userModelWithPassword.idUser}' AND tgl = '$currentDate'";
      }

      final data = _dioRequest;

      data.addAll({
        "mode": mode,
        "command": command,
      });

      debugger(message: 'here');

      log('data ${jsonEncode(data)}');

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        final absenExist = items['items'] != null && items['items'] is List;

        if (absenExist) {
          return right(unit);
        } else {
          return left(AbsenFailure.server(
            items['errornum'] as int?,
            items['error'] as String?,
          ));
        }
      } else {
        return left(AbsenFailure.server(
          items['errornum'] as int?,
          items['error'] as String?,
        ));
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

  Future<AbsenState> getAbsen() async {
    try {
      final String command =
          "SELECT TOP 1 * FROM $dbName WHERE tgl = '$currentDate' AND id_user = ${_userModelWithPassword.idUser}";

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

          log('list $list');

          if (list.isNotEmpty) {
            final item = list[0];

            final absen = Absen(
                idAbsenmnl: item['id_absenmbl'] ?? 0,
                idUser: item['id_user'] ?? 0,
                tgl: item['tgl'] ?? '',
                latitudeMasuk: item['latitude_masuk'],
                longtitudeMasuk: item['longtitude_masuk'],
                latitudeKeluar: item['latitude_keluar'],
                longtitudeKeluar: item['longtitude_keluar']);

            final sudahAbsen = absen.latitudeMasuk != null &&
                absen.longtitudeMasuk != null &&
                absen.longtitudeKeluar != null &&
                absen.longtitudeMasuk != null;

            final absenMasuk = absen.latitudeMasuk != null &&
                absen.longtitudeMasuk != null &&
                absen.longtitudeKeluar == null &&
                absen.longtitudeKeluar == null;

            final belumAbsen = absen.latitudeMasuk == null &&
                absen.longtitudeMasuk == null &&
                absen.longtitudeKeluar == null &&
                absen.longtitudeKeluar == null;

            if (sudahAbsen) {
              return AbsenState.complete();
            } else if (absenMasuk) {
              return AbsenState.absenIn();
            } else if (belumAbsen) {
              return AbsenState.incomplete();
            }

            log('null ${absen.latitudeMasuk == null} ${absen.longtitudeMasuk == null} ${absen.latitudeKeluar == null} ${absen.longtitudeKeluar == null}');
          } else {
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

  Future<RiwayatAbsenModel> getRiwayatAbsenByID(
      {required int page, required String? date}) async {
    // DATEFORMAT YYYY - MM - DD
    try {
      final String command =
          "SELECT TOP 1 id_absenmnl, id_user, tgl, jam_awal, jam_akhir, ket, c_date, c_user, spv_nm, spv_tgl, hrd_nm, hrd_tgl, btl_sta, btl_tgl, spv_note, hrd_note, latitude_masuk, longtitude_masuk, latitude_keluar, longtitude_keluar, lokasi_masuk, lokasi_keluar FROM hr_trs_absenmnl_test WHERE tgl = '$date' AND id_user = ${_userModelWithPassword.idUser} ORDER BY id_absenmnl DESC";

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
            final riwayat = list.first;

            return RiwayatAbsenModel(
              jamAwal: riwayat['jam_awal'] ?? '',
              jamAkhir: riwayat['jam_akhir'] ?? '',
              lokasiKeluar: riwayat['lokasi_keluar'] ?? '',
              lokasiMasuk: riwayat['lokasi_masuk'] ?? '',
              tgl: riwayat['tgl'],
            );
          }

          throw RestApiException(4);
        } else {
          debugger(message: 'called');

          throw RestApiException(4);
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

  Future<List<RiwayatAbsenModel>> getRiwayatAbsen(
      {required int page,
      required String? dateFirst,
      required String? dateSecond}) async {
    // DATEFORMAT YYYY - MM - DD
    try {
      final String command =
          "SELECT * FROM hr_trs_absenmnl_test WHERE id_user = '${_userModelWithPassword.idUser}' AND tgl >= '$dateSecond' AND tgl < '$dateFirst' ORDER BY tgl DESC OFFSET ${(page - 1) * 10} ROWS FETCH FIRST 20 ROWS ONLY";

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
              riwayatList.add(RiwayatAbsenModel(
                jamAwal: riwayat['jam_awal'] ?? '',
                jamAkhir: riwayat['jam_akhir'] ?? '',
                lokasiKeluar: riwayat['lokasi_keluar'] ?? '',
                lokasiMasuk: riwayat['lokasi_masuk'] ?? '',
                tgl: riwayat['tgl'],
              ));
            }

            return riwayatList;
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
