import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/absen/absen_request.dart';
import 'package:face_net_authentication/infrastructure/remote_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/absen_failure.dart';
import '../background_service/background_item_state.dart';

part 'absen_auth_state.freezed.dart';

@freezed
class AbsenAuthState with _$AbsenAuthState {
  const factory AbsenAuthState({
    required bool isSubmitting,
    required BackgroundItemState backgroundItemState,
    required RemoteResponse<AbsenRequest> absenId,
    required RemoteResponse<AbsenRequest> backgroundIdSaved,
    required Option<Either<AbsenFailure, Unit>> failureOrSuccessOption,
    required Option<Either<AbsenFailure, Unit>> failureOrSuccessOptionSaved,
  }) = _AbsenAuth;

  factory AbsenAuthState.initial() => AbsenAuthState(
      isSubmitting: false,
      backgroundItemState: BackgroundItemState.initial(),
      absenId: RemoteResponse.withNewData(AbsenRequest.absenUnknown()),
      backgroundIdSaved:
          RemoteResponse.withNewData(AbsenRequest.absenUnknown()),
      failureOrSuccessOption: none(),
      failureOrSuccessOptionSaved: none());
}
