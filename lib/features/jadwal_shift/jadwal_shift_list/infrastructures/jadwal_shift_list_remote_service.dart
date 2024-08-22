import 'package:face_net_authentication/utils/logging.dart';

import 'package:dio/dio.dart';

import '../../../../constants/constants.dart';
import '../../../../infrastructures/exceptions.dart';
import '../application/jadwal_shift_detail.dart';
import '../application/jadwal_shift_list.dart';

class JadwalShiftListRemoteService {
  JadwalShiftListRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<List<JadwalShiftDetail>> getJadwalShiftDetail({
    required int idShift,
    required String username,
    required String pass,
  }) async {
    try {
      final response = await _dio.get('/service_jdwl_shift.asmx/getShiftDtl',
          options: Options(
            headers: {
              'username': username,
              'pass': pass,
              'server': Constants.isDev ? 'testing' : 'live',
              'id_shift': idShift,
            },
          ));

      final items = response.data;

      final _data = items['data'];

      if (items['status_code'] == 200) {
        Log.info('_data is ${_data != null} ${_data.runtimeType}');

        final listExist = _data != null && _data is List;

        if (listExist) {
          if (_data.isNotEmpty) {
            return _data
                .map((e) =>
                    JadwalShiftDetail.fromJson(e as Map<String, dynamic>))
                .toList();
          } else {
            return [];
          }
        } else {
          final message = items['message'] as String?;
          final errmessage = items['error_msg'] as String?;
          final errorCode = items['status_code'] as int;

          throw RestApiExceptionWithMessage(
              errorCode, "$errorCode : $message $errmessage ");
        }
      } else {
        final message = items['message'] as String?;
        final errmessage = items['error_msg'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(
            errorCode, "$errorCode : $message $errmessage ");
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioException catch (e) {
      if ((e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout)) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<List<JadwalShiftList>> getJadwalShiftList({
    required String username,
    required String pass,
  }) async {
    try {
      final response = await _dio.get('/service_jdwl_shift.asmx/getShift',
          options: Options(
            headers: {
              'username': username,
              'pass': pass,
              'server': Constants.isDev ? 'testing' : 'live',
            },
          ));

      final items = response.data;

      final _data = items['data'];

      if (items['status_code'] == 200) {
        Log.info('_data is ${_data != null} ${_data.runtimeType}');

        final listExist = _data != null && _data is List;

        if (listExist) {
          if (_data.isNotEmpty) {
            final map = _data.map((e) => JadwalShiftList.fromJson(e)).toList();

            return map;
          } else {
            return [];
          }
        } else {
          final message = items['message'] as String?;
          final errmessage = items['error_msg'] as String?;
          final errorCode = items['status_code'] as int;

          throw RestApiExceptionWithMessage(
              errorCode, "$errorCode : $message $errmessage ");
        }
      } else {
        final message = items['message'] as String?;
        final errmessage = items['error_msg'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(
            errorCode, "$errorCode : $message $errmessage ");
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
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
