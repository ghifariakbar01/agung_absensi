import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_hrd_or_spv_absen_manual_list.freezed.dart';

@freezed
class IsHrdOrSPVAbsenManualList with _$IsHrdOrSPVAbsenManualList {
  factory IsHrdOrSPVAbsenManualList.isHrdOrSpv() = _IsHrdOrSpv;
  factory IsHrdOrSPVAbsenManualList.isRegularStaff() = _IsRegularStaff;
}
