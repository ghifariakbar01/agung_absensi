import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';
import 'package:face_net_authentication/mst_karyawan_cuti/application/mst_karyawan_cuti.dart';

import '../../../infrastructures/exceptions.dart';

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
            'server': 'testing',
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
        final errorCode = items['status_code'] as int;

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
}
