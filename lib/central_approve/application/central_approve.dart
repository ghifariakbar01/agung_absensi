// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../absen_manual/absen_manual_list/application/absen_manual_list.dart';
import '../../cuti/cuti_list/application/cuti_list.dart';
import '../../dt_pc/dt_pc_list/application/dt_pc_list.dart';
import '../../ganti_hari/ganti_hari_list/application/ganti_hari_list.dart';
import '../../izin/izin_list/application/izin_list.dart';
import '../../sakit/sakit_list/application/sakit_list.dart';
import '../../tugas_dinas/tugas_dinas_list/application/tugas_dinas_list.dart';

part 'central_approve.freezed.dart';

@freezed
abstract class CentralApprove with _$CentralApprove {
  const factory CentralApprove({
    required List<AbsenManualList> absenManualList,
    required List<CutiList> cutiList,
    required List<DtPcList> dtPcList,
    required List<GantiHariList> gantiHariList,
    required List<IzinList> izinList,
    required List<SakitList> sakitList,
    required List<TugasDinasList> tugasDinasList,
  }) = _CentralApprove;

  factory CentralApprove.initial() => CentralApprove(
      absenManualList: [],
      cutiList: [],
      dtPcList: [],
      gantiHariList: [],
      izinList: [],
      sakitList: [],
      tugasDinasList: []);

  // factory CentralApprove.fromJson(Map<String, dynamic> json) =>
  //     _$CentralApproveFromjson(json);
}
