import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../background/application/saved_location.dart';
import '../../domain/absen_failure.dart';
import '../../domain/riwayat_absen_failure.dart';
import '../../../infrastructures/cache_storage/riwayat_storage.dart';
import '../../../infrastructures/exceptions.dart';
import '../../riwayat_absen/application/riwayat_absen_model.dart';

import '../../../utils/logging.dart';
import '../../../utils/string_utils.dart';

import '../application/absen_state.dart';
import 'absen_remote_service.dart';

class AbsenRepository {
  AbsenRepository(
    this._remoteService,
    this._riwayatStorage,
  );

  final AbsenRemoteService _remoteService;
  final RiwayatStorage _riwayatStorage;

  static const String dbNameProd = 'hr_trs_absen';

  Future<bool> hasOfflineData() =>
      getRiwayatAbsenFromStorage().then((value) => value.isNotEmpty);

  Future<Option<Either<AbsenFailure, SavedLocation>>> absen({
    required int idUser,
    required String nama,
    required String imei,
    required SavedLocation item,
    required Function(SavedLocation item) onSuccess,
  }) async {
    try {
      final isIn = item.absenState == AbsenState.empty();
      final ket = isIn ? 'MASUK' : 'PULANG';
      final coancenate = isIn ? 'masuk' : 'keluar';

      final trimmedDate = StringUtils.trimmedDate(item.date);
      final trimmedDateDb = StringUtils.trimmedDate(item.dbDate);

      Map<String, dynamic> query = {
        '${item.id}': " INSERT INTO $dbNameProd " +
            "(tgljam, mode, id_user, imei, id_geof, c_date, c_user, latitude_$coancenate, longitude_$coancenate, lokasi_$coancenate)" +
            " VALUES " +
            " ('$trimmedDate', '$ket', '${idUser}', "
                " '$imei', '${item.idGeof}', '$trimmedDateDb', '${nama}', "
                " '${item.latitude}', '${item.longitude}', '${item.alamat}') ",
      };

      Log.info(query.entries.toString());

      if (query.isEmpty) {}

      await _remoteService.absen(
        absenMap: query,
      );

      onSuccess(item);

      return optionOf(right(item));
    } on NoConnectionException {
      return optionOf(left(AbsenFailure.noConnection(item)));
    } on RestApiException catch (error) {
      return optionOf(left(AbsenFailure.server(
        item: item,
        errorCode: error.errorCode,
      )));
    } on RestApiExceptionWithMessage catch (error) {
      return optionOf((left(AbsenFailure.server(
        item: item,
        errorCode: error.errorCode,
        message: error.message,
      ))));
    }
  }

  Future<AbsenState> getAbsen({
    required int idUser,
    required DateTime date,
  }) async {
    try {
      return _remoteService.getAbsen(date: date, idUser: idUser);
    } on NoConnectionException {
      return AbsenState.failure(message: 'no connection');
    } on RestApiExceptionWithMessage catch (e) {
      return AbsenState.failure(errorCode: e.errorCode, message: e.message);
    } on RestApiException catch (e) {
      return AbsenState.failure(
          errorCode: e.errorCode, message: 'RestApiException getAbsen');
    }
  }

  Future<AbsenState> getAbsenFromStorage({required DateTime date}) async {
    final riwayat = await _getRiwayatAbsenFromStorageByDate(
      dateTime: date,
    );

    if (riwayat == null) {
      return AbsenState.incomplete();
    }

    if (riwayat.pulang != null) {
      return AbsenState.complete();
    } else if (riwayat.masuk != null) {
      return AbsenState.absenIn();
    } else {
      return AbsenState.incomplete();
    }
  }

  Future<Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>>> getRiwayatAbsen({
    required int idUser,
    required String? dateFirst,
    required String? dateSecond,
  }) async {
    try {
      final resp = await _remoteService.getRiwayatAbsen(
        idUser: idUser,
        dateFirst: dateFirst,
        dateSecond: dateSecond,
      );

      if (resp.isEmpty) {
        await _riwayatStorage.clear();
      } else {
        try {
          await save(resp);
        } on PlatformException catch (_) {
          return left(RiwayatAbsenFailure.storage());
        }
      }

      return right(resp);
    } on NoConnectionException {
      return left(RiwayatAbsenFailure.noConnection());
    } on FormatException catch (e) {
      return left(RiwayatAbsenFailure.wrongFormat(e.message));
    } on RestApiException catch (e) {
      return left(RiwayatAbsenFailure.server(e.errorCode));
    } on RestApiExceptionWithMessage catch (e) {
      return left(RiwayatAbsenFailure.server(e.errorCode, e.message));
    }
  }

  Future<Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>>>
      filterRiwayatAbsen({
    required int idUser,
    required String? dateFirst,
    required String? dateSecond,
    bool isFilter = false,
  }) async {
    try {
      final resp = await _remoteService.getRiwayatAbsen(
        idUser: idUser,
        dateFirst: dateFirst,
        dateSecond: dateSecond,
      );

      return right(resp);
    } on NoConnectionException {
      return left(RiwayatAbsenFailure.noConnection());
    } on FormatException catch (e) {
      return left(RiwayatAbsenFailure.wrongFormat(e.message));
    } on RestApiException catch (e) {
      return left(RiwayatAbsenFailure.server(e.errorCode));
    } on RestApiExceptionWithMessage catch (e) {
      return left(RiwayatAbsenFailure.server(e.errorCode, e.message));
    }
  }

  Future<void> save(List<RiwayatAbsenModel> items) async {
    final encode = jsonEncode(items);
    return _riwayatStorage.save(encode);
  }

  Future<List<RiwayatAbsenModel>> getRiwayatAbsenFromStorage() async {
    final resp = await _riwayatStorage.read();
    if (resp == null) {
      return [];
    } else {
      final json = jsonDecode(resp);
      final list =
          (json as List).map((e) => RiwayatAbsenModel.fromJson(e)).toList();

      return list;
    }
  }

  Future<RiwayatAbsenModel?> _getRiwayatAbsenFromStorageByDate(
      {required DateTime dateTime}) async {
    final resp = await _riwayatStorage.read();
    if (resp == null) {
      return null;
    } else {
      final json = jsonDecode(resp);
      final list =
          (json as List).map((e) => RiwayatAbsenModel.fromJson(e)).toList();

      final item = list.firstWhereOrNull(
          (e) => DateTime.parse(e.tgl!).difference(dateTime).inDays == 0);

      return item;
    }
  }
}
