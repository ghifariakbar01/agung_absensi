import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_hrd_or_spv_ganti_hari_list.freezed.dart';

@freezed
class IsHrdOrSPVIGantiHariList with _$IsHrdOrSPVIGantiHariList {
  factory IsHrdOrSPVIGantiHariList.isHrdOrSpv() = _IsHrdOrSpv;
  factory IsHrdOrSPVIGantiHariList.isRegularStaff() = _IsRegularStaff;
}
