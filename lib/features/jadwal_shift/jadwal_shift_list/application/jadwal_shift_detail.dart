import 'package:freezed_annotation/freezed_annotation.dart';

part 'jadwal_shift_detail.freezed.dart';
part 'jadwal_shift_detail.g.dart';

@freezed
class JadwalShiftDetailParam with _$JadwalShiftDetailParam {
  const factory JadwalShiftDetailParam({
    required int idShift,
    required String jadwal,
  }) = _JadwalShiftDetailParam;

  factory JadwalShiftDetailParam.initial() => JadwalShiftDetailParam(
        idShift: 0,
        jadwal: '',
      );
}

@freezed
class JadwalShiftDetailState with _$JadwalShiftDetailState {
  const factory JadwalShiftDetailState({
    required List<JadwalShiftDetail> list,
    required List<String> namaList,
  }) = _JadwalShiftDetailState;

  factory JadwalShiftDetailState.initial() => JadwalShiftDetailState(
        list: [],
        namaList: [],
      );
}

@freezed
class JadwalShiftDetail with _$JadwalShiftDetail {
  const factory JadwalShiftDetail({
    @JsonKey(name: 'id_shift_dtl') int? idShiftDtl,
    @JsonKey(name: 'id_shift') int? idShift,
    @JsonKey(name: 'tgl') DateTime? tgl,
    @JsonKey(name: 'jadwal') String? jadwal,
    @JsonKey(name: 'c_date') DateTime? cDate,
    @JsonKey(name: 'c_user') String? cUser,
    @JsonKey(name: 'u_date') DateTime? uDate,
    @JsonKey(name: 'u_user') String? uUser,
    @JsonKey(name: 'jdwl_in') String? jdwlIn,
    @JsonKey(name: 'jdwl_out') String? jdwlOut,
    @JsonKey(name: 'fullname') String? fullname,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'email2') String? email2,
    @JsonKey(name: 'u_by') String? uBy,
    @JsonKey(name: 'c_by') String? cBy,
    @JsonKey(name: 'is_edit') bool? isEdit,
  }) = _JadwalShiftDetail;

  factory JadwalShiftDetail.initial() => JadwalShiftDetail();

  factory JadwalShiftDetail.fromJson(Map<String, dynamic> json) =>
      _$JadwalShiftDetailFromJson(json);
}
