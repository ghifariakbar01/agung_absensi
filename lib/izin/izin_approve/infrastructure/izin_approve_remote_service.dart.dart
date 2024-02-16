// import 'dart:convert';
// import 'dart:developer';

// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

// import '../../../infrastructure/exceptions.dart';
// import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
// import '../../create_sakit/application/create_sakit.dart';

// import '../../sakit_list/application/sakit_list.dart';

// class SakitApproveRemoteService {
//   SakitApproveRemoteService(
//     this._dio,
//     this._dioRequest,
//   );

//   final Dio _dio;
//   final Map<String, String> _dioRequest;

//   static const String dbName = 'hr_trs_sakit';
//   static const String dbMstCutiNew = 'hr_mst_cuti_new';
//   //

//   Future<Unit> approveSpv(
//       {required int idSakit,
//       required String nama,
//       required String note}) async {
//     try {
//       final Map<String, String> updateSakit = {
//         "command": "UPDATE $dbName SET "
//                 " spv_nm = '$nama', " +
//             " spv_sta = 1, " +
//             " spv_tgl = getdate(), " +
//             " spv_note = '$note' " +
//             " WHERE id_sakit = $idSakit ",
//         "mode": "UPDATE"
//       };

//       final data = _dioRequest;
//       data.addAll(updateSakit);

//       final response = await _dio.post('',
//           data: jsonEncode(data), options: Options(contentType: 'text/plain'));

//       log('data ${jsonEncode(data)}');
//       log('response $response');
//       final items = response.data?[0];

//       if (items['status'] == 'Success') {
//         return unit;
//       } else {
//         final message = items['error'] as String?;
//         final errorCode = items['errornum'] as int;

//         throw RestApiExceptionWithMessage(errorCode, message);
//       }
//     } on FormatException catch (e) {
//       throw FormatException(e.message);
//     } on DioError catch (e) {
//       if (e.isNoConnectionError || e.isConnectionTimeout) {
//         throw NoConnectionException();
//       } else if (e.response != null) {
//         throw RestApiException(e.response?.statusCode);
//       } else {
//         rethrow;
//       }
//     }
//   }

//   Future<Unit> approveHrdDenganSurat({
//     required String nama,
//     required String note,
//     required SakitList itemSakit,
//   }) async {
//     // 1. UPDATE SAKIT
//     try {
//       final Map<String, String> updateSakit = {
//         "command": "UPDATE $dbName SET "
//                 " hrd_nm = '$nama', " +
//             " hrd_sta = 1, " +
//             " hrd_tgl = getdate(), " +
//             " hrd_note = '$note' " +
//             " WHERE id_sakit = ${itemSakit.idSakit} ",
//         "mode": "UPDATE"
//       };

//       final data = _dioRequest;
//       data.addAll(updateSakit);

//       final response = await _dio.post('',
//           data: jsonEncode(data), options: Options(contentType: 'text/plain'));

//       log('data ${jsonEncode(data)}');
//       log('response $response');
//       final items = response.data?[0];

//       if (items['status'] == 'Success') {
//         return unit;
//       } else {
//         final message = items['error'] as String?;
//         final errorCode = items['errornum'] as int;

//         throw RestApiExceptionWithMessage(errorCode, message);
//       }
//     } on FormatException catch (e) {
//       throw FormatException(e.message);
//     } on DioError catch (e) {
//       if (e.isNoConnectionError || e.isConnectionTimeout) {
//         throw NoConnectionException();
//       } else if (e.response != null) {
//         throw RestApiException(e.response?.statusCode);
//       } else {
//         rethrow;
//       }
//     }
//   }

//   Future<Unit> approveHrdTanpaSurat({
//     required String note,
//     required String namaHrd,
//     required SakitList itemSakit,
//     required CreateSakit createSakit,
//     required MstKaryawanCuti mstCutiUser,
//   }) async {
//     // 2. CALC SALDO CUTI

//     // jika cuti baru habis dengan total hari sakit maka
//     // cuti baru = 0
//     // jika tidak habis maka jumlah cuti baru = cuti baru - total hari sakit
//     final int cutiBaruOld = mstCutiUser.cutiBaru!;
//     final int cutiBaruNew =
//         itemSakit.totHari! == 0 ? 0 : cutiBaruOld - itemSakit.totHari!;

//     if (cutiBaruNew == 0) {
//       // jika open date = close date
//       // maka close date masih sama
//       // jika tidak maka close date ditambah satu tahun
//       // open date akan ditambah satu tahun terlepas dari semua kondisi

//       final openDateOld = mstCutiUser.openDate;
//       final openDateOldPlusOneYear =
//           mstCutiUser.openDate!.add(Duration(days: 365));

//       final closeDateOld = mstCutiUser.closeDate;
//       final closeDateOldPlusOneYear =
//           mstCutiUser.closeDate!.add(Duration(days: 365));

//       DateTime? closeDateNew;
//       DateTime? openDateNew;

//       // 2.a CALC CLOSE DATE
//       if (openDateOld == closeDateOld) {
//         closeDateNew = closeDateOld;
//       } else {
//         closeDateNew = DateTime.parse("${closeDateOldPlusOneYear.year}-01-01");
//       }

//       // 2.b CALC OPEN DATE
//       openDateNew = DateTime.parse("${openDateOldPlusOneYear.year}-01-01");

//       try {
//         final Map<String, String> updateSakitCutiBaru = {
//           "command": " UPDATE $dbMstCutiNew SET "
//               " cuti_baru  = '$cutiBaruNew', "
//               " close_date  = '$closeDateNew', "
//               " open_date  = '$openDateNew' "
//               " WHERE id_mst_cuti =  ${mstCutiUser.idMstCuti} "
//               //
//               " UPDATE $dbName SET "
//               " sisa_cuti  = '$cutiBaruNew', "
//               " WHERE id_sakit =  ${itemSakit.idSakit} ",
//           "mode": "UPDATE"
//         };

//         final data = _dioRequest;
//         data.addAll(updateSakitCutiBaru);

//         final response = await _dio.post('',
//             data: jsonEncode(data),
//             options: Options(contentType: 'text/plain'));

//         log('data ${jsonEncode(data)}');
//         log('response $response');
//         final items = response.data?[0];

//         if (items['status'] == 'Success') {
//           return unit;
//         } else {
//           final message = items['error'] as String?;
//           final errorCode = items['errornum'] as int;

//           throw RestApiExceptionWithMessage(errorCode, message);
//         }
//       } on FormatException catch (e) {
//         throw FormatException(e.message);
//       } on DioError catch (e) {
//         if (e.isNoConnectionError || e.isConnectionTimeout) {
//           throw NoConnectionException();
//         } else if (e.response != null) {
//           throw RestApiException(e.response?.statusCode);
//         } else {
//           rethrow;
//         }
//       }
//     } else {
//       // jika cuti tidak baru habis dengan total hari sakit maka
//       // cuti tidak baru = 12
//       // jika tidak habis maka jumlah cuti tidak baru = cuti tidak baru - total hari sakit
//       // jika jumlah cuti tidak baru = 12
//       // maka tahun cuti tidak baru ditambah satu tahun, dan open date masih sama
//       // dan jika open date = close date maka close date masih sama
//       // jika open date != close date maka close date = close date ditambah satu tahun

//       final int cutiTidakBaruOld = mstCutiUser.cutiTidakBaru!;
//       final int cutiTidakBaruNew = cutiTidakBaruOld - itemSakit.totHari! == 0
//           ? 12
//           : cutiTidakBaruOld - itemSakit.totHari!;

//       int? tahunCutiTidakBaru;

//       final openDateOld = mstCutiUser.openDate;
//       final openDateOldPlusOneYear =
//           mstCutiUser.openDate!.add(Duration(days: 365));

//       final closeDateOld = mstCutiUser.closeDate;
//       final closeDateOldPlusOneYear =
//           mstCutiUser.closeDate!.add(Duration(days: 365));

//       DateTime? closeDateNew;
//       DateTime? openDateNew;

//       if (cutiTidakBaruNew == 12) {
//         tahunCutiTidakBaru = openDateOld!.add(Duration(days: 365)).year;
//         openDateNew = DateTime.parse("${openDateOldPlusOneYear.year}-01-01");

//         if (openDateOld == closeDateOld) {
//           closeDateNew = DateTime.parse("${closeDateOld!.year}-01-01");
//         } else {
//           closeDateNew =
//               DateTime.parse("${closeDateOldPlusOneYear.year}-01-01");
//         }
//       }

//       try {
//         final Map<String, String> updateSakitCutiTidakBaru = {
//           "command": "UPDATE $dbMstCutiNew SET "
//               " cuti_tidak_baru  = $cutiTidakBaruNew "
//               " ${tahunCutiTidakBaru != null ? ", tahun_cuti_tidak_baru  = $tahunCutiTidakBaru, " : ""}  "
//               " ${openDateNew != null ? " open_date = $openDateNew, " : ""} "
//               " ${closeDateNew != null ? " close_date = $closeDateNew " : ""} "
//               " WHERE id_mst_cuti =  ${mstCutiUser.idMstCuti} "
//               //
//               " UPDATE $dbName SET "
//               " sisa_cuti  = '$cutiTidakBaruNew' "
//               " WHERE id_sakit =  ${itemSakit.idSakit} ",
//           "mode": "UPDATE"
//         };
//         final data = _dioRequest;
//         data.addAll(updateSakitCutiTidakBaru);

//         final response = await _dio.post('',
//             data: jsonEncode(data),
//             options: Options(contentType: 'text/plain'));

//         log('data ${jsonEncode(data)}');
//         log('response $response');
//         final items = response.data?[0];

//         if (items['status'] == 'Success') {
//           // return unit;
//         } else {
//           final message = items['error'] as String?;
//           final errorCode = items['errornum'] as int;

//           throw RestApiExceptionWithMessage(errorCode, message);
//         }
//       } on FormatException catch (e) {
//         throw FormatException(e.message);
//       } on DioError catch (e) {
//         if (e.isNoConnectionError || e.isConnectionTimeout) {
//           throw NoConnectionException();
//         } else if (e.response != null) {
//           throw RestApiException(e.response?.statusCode);
//         } else {
//           rethrow;
//         }
//       }
//     }

//     // 1. UPDATE SAKIT
//     try {
//       final Map<String, String> updateSakit = {
//         "command": "UPDATE $dbName SET "
//                 " hrd_nm = '$namaHrd', " +
//             " hrd_sta = 1, " +
//             " hrd_tgl = getdate(), " +
//             " hrd_note = '$note' " +
//             " WHERE id_sakit = ${itemSakit.idSakit} ",
//         "mode": "UPDATE"
//       };

//       final data = _dioRequest;
//       data.addAll(updateSakit);

//       final response = await _dio.post('',
//           data: jsonEncode(data), options: Options(contentType: 'text/plain'));

//       log('data ${jsonEncode(data)}');
//       log('response $response');
//       final items = response.data?[0];

//       if (items['status'] == 'Success') {
//         return unit;
//       } else {
//         final message = items['error'] as String?;
//         final errorCode = items['errornum'] as int;

//         throw RestApiExceptionWithMessage(errorCode, message);
//       }
//     } on FormatException catch (e) {
//       throw FormatException(e.message);
//     } on DioError catch (e) {
//       if (e.isNoConnectionError || e.isConnectionTimeout) {
//         throw NoConnectionException();
//       } else if (e.response != null) {
//         throw RestApiException(e.response?.statusCode);
//       } else {
//         rethrow;
//       }
//     }
//   }

//   Future<Unit> unApproveHrdDenganSurat({
//     required String nama,
//     required SakitList itemSakit,
//   }) async {
//     // 1. UPDATE SAKIT
//     try {
//       final Map<String, String> updateSakit = {
//         "command": "UPDATE $dbName SET "
//                 " hrd_nm = '$nama', " +
//             " hrd_sta = 0, " +
//             " hrd_tgl = getdate() " +
//             " WHERE id_sakit = ${itemSakit.idSakit} ",
//         "mode": "UPDATE"
//       };

//       final data = _dioRequest;
//       data.addAll(updateSakit);

//       final response = await _dio.post('',
//           data: jsonEncode(data), options: Options(contentType: 'text/plain'));

//       log('data ${jsonEncode(data)}');
//       log('response $response');
//       final items = response.data?[0];

//       if (items['status'] == 'Success') {
//         return unit;
//       } else {
//         final message = items['error'] as String?;
//         final errorCode = items['errornum'] as int;

//         throw RestApiExceptionWithMessage(errorCode, message);
//       }
//     } on FormatException catch (e) {
//       throw FormatException(e.message);
//     } on DioError catch (e) {
//       if (e.isNoConnectionError || e.isConnectionTimeout) {
//         throw NoConnectionException();
//       } else if (e.response != null) {
//         throw RestApiException(e.response?.statusCode);
//       } else {
//         rethrow;
//       }
//     }
//   }

//   Future<Unit> unApproveHrdTanpaSurat({
//     required String nama,
//     required SakitList itemSakit,
//     required CreateSakit createSakit,
//     required MstKaryawanCuti mstCuti,
//   }) async {
//     // 1. UPDATE SAKIT
//     try {
//       int? cutiTidakBaruNew;
//       int? cutiBaruNew;
//       DateTime masuk = DateTime.parse(createSakit.masuk!);

//       if (masuk.year != mstCuti.openDate!.year) {
//         cutiTidakBaruNew = mstCuti.cutiTidakBaru! + itemSakit.totHari!;
//       } else {
//         cutiBaruNew = mstCuti.cutiBaru! + itemSakit.totHari!;
//       }

//       final Map<String, String> updateSakit = {
//         "command": "UPDATE $dbName SET "
//                 " hrd_nm = '$nama', " +
//             " hrd_sta = 0, " +
//             " hrd_tgl = getdate() " +
//             " WHERE id_sakit = ${itemSakit.idSakit} "
//                 //
//                 " UPDATE $dbMstCutiNew SET "
//                 " ${cutiTidakBaruNew != null ? " cuti_tidak_baru = $cutiTidakBaruNew " : ""} " +
//             " ${cutiBaruNew != null ? " cuti_baru = $cutiBaruNew " : ""} " +
//             " WHERE FORMAT(open_date, 'yyyy-01-01') = '${mstCuti.openDate!.year}-01-01' "
//                 " AND id_user = ${itemSakit.idUser} ",
//         "mode": "UPDATE"
//       };

//       final data = _dioRequest;
//       data.addAll(updateSakit);

//       final response = await _dio.post('',
//           data: jsonEncode(data), options: Options(contentType: 'text/plain'));

//       log('data ${jsonEncode(data)}');
//       log('response $response');
//       final items = response.data?[0];

//       if (items['status'] == 'Success') {
//         return unit;
//       } else {
//         final message = items['error'] as String?;
//         final errorCode = items['errornum'] as int;

//         throw RestApiExceptionWithMessage(errorCode, message);
//       }
//     } on FormatException catch (e) {
//       throw FormatException(e.message);
//     } on DioError catch (e) {
//       if (e.isNoConnectionError || e.isConnectionTimeout) {
//         throw NoConnectionException();
//       } else if (e.response != null) {
//         throw RestApiException(e.response?.statusCode);
//       } else {
//         rethrow;
//       }
//     }
//   }

//   Future<Unit> unApproveSpv({
//     required String nama,
//     required SakitList itemSakit,
//   }) async {
//     // 1. UPDATE SAKIT
//     try {
//       final Map<String, String> updateSakit = {
//         "command": "UPDATE $dbName SET "
//                 " spv_nm = '$nama', " +
//             " spv_sta = 0, " +
//             " spv_tgl = getdate() " +
//             " WHERE id_sakit = ${itemSakit.idSakit} ",
//         "mode": "UPDATE"
//       };

//       final data = _dioRequest;
//       data.addAll(updateSakit);

//       final response = await _dio.post('',
//           data: jsonEncode(data), options: Options(contentType: 'text/plain'));

//       log('data ${jsonEncode(data)}');
//       log('response $response');
//       final items = response.data?[0];

//       if (items['status'] == 'Success') {
//         return unit;
//       } else {
//         final message = items['error'] as String?;
//         final errorCode = items['errornum'] as int;

//         throw RestApiExceptionWithMessage(errorCode, message);
//       }
//     } on FormatException catch (e) {
//       throw FormatException(e.message);
//     } on DioError catch (e) {
//       if (e.isNoConnectionError || e.isConnectionTimeout) {
//         throw NoConnectionException();
//       } else if (e.response != null) {
//         throw RestApiException(e.response?.statusCode);
//       } else {
//         rethrow;
//       }
//     }
//   }

//   Future<Unit> batal({
//     required String nama,
//     required SakitList itemSakit,
//   }) async {
//     // 1. UPDATE SAKIT
//     try {
//       final Map<String, String> updateSakit = {
//         "command": "UPDATE $dbName SET "
//                 " btl_nm = '$nama', " +
//             " btl_sta = 1, " +
//             " btl_tgl = getdate() " +
//             " WHERE id_sakit = ${itemSakit.idSakit} ",
//         "mode": "UPDATE"
//       };

//       final data = _dioRequest;
//       data.addAll(updateSakit);

//       final response = await _dio.post('',
//           data: jsonEncode(data), options: Options(contentType: 'text/plain'));

//       log('data ${jsonEncode(data)}');
//       log('response $response');
//       final items = response.data?[0];

//       if (items['status'] == 'Success') {
//         return unit;
//       } else {
//         final message = items['error'] as String?;
//         final errorCode = items['errornum'] as int;

//         throw RestApiExceptionWithMessage(errorCode, message);
//       }
//     } on FormatException catch (e) {
//       throw FormatException(e.message);
//     } on DioError catch (e) {
//       if (e.isNoConnectionError || e.isConnectionTimeout) {
//         throw NoConnectionException();
//       } else if (e.response != null) {
//         throw RestApiException(e.response?.statusCode);
//       } else {
//         rethrow;
//       }
//     }
//   }
// }
