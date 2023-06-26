import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/riwayat_absen/riwayat_absen_model.dart';
import 'package:face_net_authentication/domain/riwayat_absen_failure.dart';
import 'package:face_net_authentication/utils/string_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'riwayat_absen_state.freezed.dart';

@freezed
class RiwayatAbsenState with _$RiwayatAbsenState {
  const factory RiwayatAbsenState(
      {required List<RiwayatAbsenModel> riwayatAbsen,
      required int page,
      required String? dateFirst,
      required String? dateSecond,
      required bool isMore,
      required bool isGetting,
      required Option<Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>>>
          failureOrSuccessOption,
      required Option<Either<RiwayatAbsenFailure, RiwayatAbsenModel>>
          failureOrSuccessOptionByID}) = _RiwayatAbsenState;

  factory RiwayatAbsenState.initial() => RiwayatAbsenState(
      riwayatAbsen: [],
      isMore: true,
      isGetting: false,
      failureOrSuccessOption: none(),
      failureOrSuccessOptionByID: none(),
      dateFirst: StringUtils.yyyyMMddWithStripe(DateTime.now()),
      dateSecond: StringUtils.yyyyMMddWithStripe(
          DateTime.now().subtract(Duration(days: 7))),
      page: 1);
}
