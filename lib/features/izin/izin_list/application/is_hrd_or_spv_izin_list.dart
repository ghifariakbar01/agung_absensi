import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_hrd_or_spv_izin_list.freezed.dart';

@freezed
class IsHrdOrSPVIzinList with _$IsHrdOrSPVIzinList {
  factory IsHrdOrSPVIzinList.isHrdOrSpv() = _IsHrdOrSpv;
  factory IsHrdOrSPVIzinList.isRegularStaff() = _IsRegularStaff;
}
