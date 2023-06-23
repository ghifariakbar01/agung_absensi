import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/absen/absen_request.dart';
import 'package:face_net_authentication/infrastructure/remote_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/absen_failure.dart';

part 'absen_auth_state.freezed.dart';

@freezed
class AbsenAuthState with _$AbsenAuthState {
  const factory AbsenAuthState(
          {required bool isSubmitting,
          required RemoteResponse<AbsenRequest> absenId,
          required Option<Either<AbsenFailure, Unit>> failureOrSuccessOption}) =
      _AbsenAuth;

  factory AbsenAuthState.initial() => AbsenAuthState(
        isSubmitting: false,
        absenId: RemoteResponse.withNewData(AbsenRequest.absenUnknown()),
        failureOrSuccessOption: none(),
      );
}
