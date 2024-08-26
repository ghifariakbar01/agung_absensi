import 'package:freezed_annotation/freezed_annotation.dart';

part 'jadwal_shift_list.freezed.dart';
part 'jadwal_shift_list.g.dart';

@freezed
class JadwalShiftList with _$JadwalShiftList {
  const factory JadwalShiftList({
    @JsonKey(name: 'id_shift') int? idShift,
    @JsonKey(name: 'id_user') int? idUser,
    @JsonKey(name: 'periode') DateTime? periode,
    @JsonKey(name: 'c_date') DateTime? cDate,
    @JsonKey(name: 'c_user') String? cUser,
    @JsonKey(name: 'u_date') DateTime? uDate,
    @JsonKey(name: 'u_user') String? uUser,
    @JsonKey(name: 'spv_sta') bool? spvSta,
    @JsonKey(name: 'spv_date') DateTime? spvDate,
    @JsonKey(name: 'spv_nm') String? spvNm,
    @JsonKey(name: 'IdKary') String? idKary,
    @JsonKey(name: 'staf_sta') bool? stafSta,
    @JsonKey(name: 'staf_date') DateTime? stafDate,
    @JsonKey(name: 'staf_nm') String? stafNm,
    @JsonKey(name: 'fullname') String? fullname,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'email2') String? email2,
    @JsonKey(name: 'no_off') int? noOff,
    @JsonKey(name: 'app_staf') String? appStaf,
    @JsonKey(name: 'app_spv') String? appSpv,
    @JsonKey(name: 'u_by') String? uBy,
    @JsonKey(name: 'c_by') String? cBy,
    @JsonKey(name: 'is_edit') bool? isEdit,
    @JsonKey(name: 'is_delete') bool? isDelete,
    @JsonKey(name: 'is_staf') bool? isStaf,
    @JsonKey(name: 'staf_msg') String? stafMsg,
    @JsonKey(name: 'is_spv') bool? isSpv,
    @JsonKey(name: 'spv_msg') String? spvMsg,
    @JsonKey(name: 'is_btl') bool? isBtl,
    @JsonKey(name: 'btl_msg') String? btlMsg,
    int? week,
  }) = _JadwalShiftList;

  factory JadwalShiftList.fromJson(Map<String, dynamic> json) =>
      _$JadwalShiftListFromJson(json);
}
