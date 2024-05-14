import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_hrd_or_spv_dt_pc_list.freezed.dart';

@freezed
class IsHrdOrSPVIDtPcList with _$IsHrdOrSPVIDtPcList {
  factory IsHrdOrSPVIDtPcList.isHrdOrSpv() = _IsHrdOrSpv;
  factory IsHrdOrSPVIDtPcList.isRegularStaff() = _IsRegularStaff;
}
