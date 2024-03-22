import 'package:face_net_authentication/absen_manual/absen_manual_list/application/absen_manual_list_notifier.dart';
import 'package:face_net_authentication/cuti/cuti_list/application/cuti_list_notifier.dart';
import 'package:face_net_authentication/dt_pc/dt_pc_list/application/dt_pc_list_notifier.dart';
import 'package:face_net_authentication/ganti_hari/ganti_hari_list/application/ganti_hari_list_notifier.dart';
import 'package:face_net_authentication/izin/izin_list/application/izin_list_notifier.dart';
import 'package:face_net_authentication/sakit/sakit_list/application/sakit_list_notifier.dart';
import 'package:face_net_authentication/tugas_dinas/tugas_dinas_list/application/tugas_dinas_list_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'central_approve.dart';
part 'central_approve_notifier.g.dart';

/*
    absen_manual
    cuti
    dt_pc
    izin
    sakit
    tugas_dinas
    ganti_hari
  */

@riverpod
class CentralApproveListNotifier extends _$CentralApproveListNotifier {
  @override
  FutureOr<CentralApprove> build() async {
    final absenManualList =
        await ref.read(absenManualListControllerProvider.notifier).build();
    final cutiList =
        await ref.read(cutiListControllerProvider.notifier).build();
    final dtPcList =
        await ref.read(dtPcListControllerProvider.notifier).build();
    final gantiHariList =
        await ref.read(gantiHariListControllerProvider.notifier).build();
    final izinList =
        await ref.read(izinListControllerProvider.notifier).build();
    final sakitList =
        await ref.read(sakitListControllerProvider.notifier).build();
    final tugasDinasList =
        await ref.read(tugasDinasListControllerProvider.notifier).build();

    return CentralApprove(
        absenManualList: absenManualList,
        cutiList: cutiList,
        dtPcList: dtPcList,
        gantiHariList: gantiHariList,
        izinList: izinList,
        sakitList: sakitList,
        tugasDinasList: tugasDinasList);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard<CentralApprove>(() async {
      final absenManualList =
          await ref.read(absenManualListControllerProvider.notifier).build();
      final cutiList =
          await ref.read(cutiListControllerProvider.notifier).build();
      // final dtPcList =
      //     await ref.read(dtPcListControllerProvider.notifier).build();
      // final gantiHariList =
      //     await ref.read(gantiHariListControllerProvider.notifier).build();
      // final izinList =
      //     await ref.read(izinListControllerProvider.notifier).build();
      // final sakitList =
      //     await ref.read(sakitListControllerProvider.notifier).build();
      // final tugasDinasList =
      //     await ref.read(tugasDinasListControllerProvider.notifier).build();

      return CentralApprove(
          absenManualList: absenManualList,
          cutiList: cutiList,
          dtPcList: [],
          gantiHariList: [],
          izinList: [],
          sakitList: [],
          tugasDinasList: []);
    });
  }
}
