// import 'dart:convert';

// import 'package:dio/dio.dart';

// import '../application/network_response.dart';

// class NetworkStateRemoteService {
//   NetworkStateRemoteService(
//     this._dio,
//     this._dioRequestNotifier,
//   );

//   final Dio _dio;
//   final Map<String, String> _dioRequestNotifier;

//   Future<NetworkResponse> ping({
//     required String nama,
//     required String password,
//   }) async {
//     try {
//       final data = _dioRequestNotifier;

//       data.addAll({
//         "username": nama,
//         "password": password,
//         "mode": "SELECT",
//         "command": "SELECT * FROM mst_user WHERE nama LIKE '%$nama%'",
//       });

//       final response = await _dio.post(
//         '',
//         data: jsonEncode(data),
//         options: Options(contentType: 'text/plain'),
//       );

//       final items = response.data?[0];

//       if (items['status'] == 'Success') {
//         return NetworkResponse.withData();
//       } else {
//         final message = items['error'] as String?;
//         final errorCode = items['errornum'] as int;

//         return NetworkResponse.failure(
//           errorCode: errorCode,
//           message: message,
//         );
//       }
//     } on DioException catch (e) {
//       if (e.type == DioExceptionType.unknown ||
//           e.type == DioExceptionType.connectionError ||
//           e.type == DioExceptionType.connectionTimeout ||
//           e.type == DioExceptionType.receiveTimeout ||
//           e.type == DioExceptionType.sendTimeout) {
//         return NetworkResponse.failure(
//           errorCode: 500,
//           message: 'Bad Request (Timeout)',
//         );
//       } else if (e.response != null) {
//         return NetworkResponse.failure(
//           errorCode: 500,
//           message: 'Bad Request (Exception)',
//         );
//       } else {
//         rethrow;
//       }
//     }
//   }
// }
