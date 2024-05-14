import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_hrd_or_spv_tugas_dinas_list.freezed.dart';

@freezed
class IsHrdOrSPVTugasDinasList with _$IsHrdOrSPVTugasDinasList {
  factory IsHrdOrSPVTugasDinasList.isHrdOrSpv() = _IsHrdOrSpv;
  factory IsHrdOrSPVTugasDinasList.isRegularStaff() = _IsRegularStaff;
}
