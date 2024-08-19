// ignore_for_file: sdk_version_since

import 'package:dartz/dartz.dart';

import 'package:face_net_authentication/domain/riwayat_absen_failure.dart';
import 'package:face_net_authentication/utils/string_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'riwayat_absen_model.dart';

part 'riwayat_absen_state.freezed.dart';

@freezed
class RiwayatAbsenState with _$RiwayatAbsenState {
  const factory RiwayatAbsenState({
    required List<RiwayatAbsenModel> riwayatAbsen,
    required int page,
    required String? dateFirst,
    required String? dateSecond,
    required bool isMore,
    required bool isGetting,
    required Option<Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>>>
        failureOrSuccessOption,
  }) = _RiwayatAbsenState;

  factory RiwayatAbsenState.initial() => RiwayatAbsenState(
        riwayatAbsen: [],
        isMore: true,
        isGetting: false,
        failureOrSuccessOption: none(),
        dateFirst: StringUtils.yyyyMMddWithStripe(
            DateTime.now().add(Duration(days: 1))),
        dateSecond: StringUtils.yyyyMMddWithStripe(DateTime.now().copyWith(
          month: DateTime.now().month - 1,
          day: 15,
        )),
        page: 1,
      );
}
