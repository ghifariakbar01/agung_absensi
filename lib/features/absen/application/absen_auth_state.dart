import 'package:dartz/dartz.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../background/application/saved_location.dart';
import '../../domain/absen_failure.dart';

part 'absen_auth_state.freezed.dart';

@freezed
class AbsenAuthState with _$AbsenAuthState {
  const factory AbsenAuthState({
    required bool isSubmitting,
    required List<SavedLocation> absenProcessedList,
    required List<Option<Either<AbsenFailure, SavedLocation>>>
        failureOrSuccessOptionList,
  }) = _AbsenAuth;

  factory AbsenAuthState.initial() => AbsenAuthState(
        isSubmitting: false,
        failureOrSuccessOptionList: [],
        absenProcessedList: [
          SavedLocation.initial(),
          SavedLocation.initial(),
          SavedLocation.initial()
        ],
      );
}
