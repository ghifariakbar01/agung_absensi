import 'package:dio/dio.dart';

import 'package:face_net_authentication/mst_karyawan_cuti/application/mst_karyawan_cuti.dart';

import '../../../infrastructures/exceptions.dart';
import '../../constants/constants.dart';

class MstKaryawanCutiRemoteService {
  MstKaryawanCutiRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<MstKaryawanCuti> getSaldoMasterCuti({
    required int idUser,
  }) async {
    try {
      final response = await _dio.post('/service_master.asmx/getCutiUser',
          options: Options(contentType: 'text/plain', headers: {
            'id_user': idUser,
            'server': Constants.isDev ? 'testing' : 'live',
          }));

      final items = response.data;

      if (items['status_code'] == 200) {
        final list = items['data'] as List;

        if (list.isNotEmpty) {
          final item = list[0];
          return MstKaryawanCuti.fromJson(item);
        } else {
          return MstKaryawanCuti.initial();
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
      if ((e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout)) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
