import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:face_net_authentication/infrastructure/absen/absen_remote_service.dart';
import 'package:face_net_authentication/infrastructure/remote_response.dart';

import '../../application/absen/absen_request.dart';
import '../../application/absen/absen_state.dart';
import '../../application/riwayat_absen/riwayat_absen_model.dart';
import '../../domain/absen_failure.dart';
import '../../domain/riwayat_absen_failure.dart';
import '../exceptions.dart';

class AbsenRepository {
  AbsenRepository(
    this._remoteService,
  );

  final AbsenRemoteService _remoteService;

  Future<Either<AbsenFailure, Unit>> absen({
    required String idAbsenMnl,
    required String lokasi,
    required String latitude,
    required String longitude,
    required JenisAbsen inOrOut,
    required String jenisAbsen,
  }) async {
    try {
      await _remoteService.absen(
        idAbsenMnl: idAbsenMnl,
        lokasi: lokasi,
        latitude: latitude,
        longitude: longitude,
        inOrOut: inOrOut,
        jenisAbsen: jenisAbsen,
      );

      return right(unit);
    } on NoConnectionException {
      return left(AbsenFailure.noConnection());
    } on RestApiException {
      return left(AbsenFailure.server(503, 'Error rest api exception'));
    }
  }

  Future<RemoteResponse<AbsenRequest>> getAbsenId(JenisAbsen jenis) async {
    try {
      final response = await _remoteService.getAbsenID();

      debugger(message: 'called');

      log('respones $response');

      if (response != null) {
        switch (jenis) {
          case JenisAbsen.absenIn:
            return RemoteResponse.withNewData(
                AbsenRequest.absenIn(absenIdMnl: response));
          case JenisAbsen.absenOut:
            return RemoteResponse.withNewData(
                AbsenRequest.absenOut(absenIdMnl: response));
          default:
            return RemoteResponse.failure(
                errorCode: 503, message: 'Error absen ');
        }
      }

      return RemoteResponse.failure(errorCode: 0, message: 'Error null');
    } on NoConnectionException {
      return RemoteResponse.failure(errorCode: 502, message: 'no connection');
    } on RestApiException {
      return RemoteResponse.failure(
          errorCode: 502, message: 'Error rest api exception');
    }
  }

  Future<RemoteResponse<AbsenState>> getAbsen() async {
    try {
      return RemoteResponse.withNewData(await _remoteService.getAbsen());
    } on NoConnectionException {
      return RemoteResponse.failure(errorCode: 502, message: 'no connection');
    } on RestApiException {
      return RemoteResponse.failure(
          errorCode: 502, message: 'Error rest api exception');
    }
  }

  Future<Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>>> getRiwayatAbsen(
      {required int page,
      required String? dateFirst,
      required String? dateSecond}) async {
    try {
      return right(await _remoteService.getRiwayatAbsen(
          page: page, dateFirst: dateFirst, dateSecond: dateSecond));
    } on FormatException {
      return left(RiwayatAbsenFailure.wrongFormat());
    } on NoConnectionException {
      return left(RiwayatAbsenFailure.noConnection());
    } on RestApiException {
      return left(RiwayatAbsenFailure.server());
    }
  }

  Future<Either<RiwayatAbsenFailure, RiwayatAbsenModel>> getRiwayatAbsenByID(
      {required int page, required String? date}) async {
    try {
      return right(
          await _remoteService.getRiwayatAbsenByID(page: page, date: date));
    } on FormatException {
      return left(RiwayatAbsenFailure.wrongFormat());
    } on NoConnectionException {
      return left(RiwayatAbsenFailure.noConnection());
    } on RestApiException {
      return left(RiwayatAbsenFailure.server());
    }
  }
}
