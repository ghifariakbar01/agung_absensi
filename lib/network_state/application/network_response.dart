import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_response.freezed.dart';

@freezed
class NetworkResponse with _$NetworkResponse {
  const factory NetworkResponse.withData() = _WithData;
  const factory NetworkResponse.noConnection() = _NoConnection;
  const factory NetworkResponse.failure({
    int? errorCode,
    String? message,
  }) = _Failure;

  const NetworkResponse._();
}
