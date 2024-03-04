import 'package:face_net_authentication/absen_manual/absen_manual_list/application/absen_manual_list_notifier.dart';
import 'package:face_net_authentication/cuti/cuti_list/application/cuti_list_notifier.dart';
import 'package:face_net_authentication/dt_pc/dt_pc_list/application/dt_pc_list_notifier.dart';
import 'package:face_net_authentication/izin/izin_list/application/izin_list_notifier.dart';
import 'package:face_net_authentication/sakit/sakit_list/application/sakit_list_notifier.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:face_net_authentication/tugas_dinas/tugas_dinas_list/application/tugas_dinas_list_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'central_approve_notifier.g.dart';

/*
absen_manual
cuti
dt_pc
izin
sakit
tugas_dinas
*/

@riverpod
class CentralApproveNotifier extends _$CentralApproveNotifier {
  @override
  FutureOr<void> build() async {}

  bool isSpv() {
    final spv = ref.read(userNotifierProvider).user.spv;

    final spvCuti =
        ref.read(cutiListControllerProvider.notifier).isHrdOrSpv(spv);
    final spvDtPc =
        ref.read(dtPcListControllerProvider.notifier).isHrdOrSpv(spv);
    final spvIzin =
        ref.read(izinListControllerProvider.notifier).isHrdOrSpv(spv);
    final spvSakit =
        ref.read(sakitListControllerProvider.notifier).isHrdOrSpv(spv);
    final spvTugasDinas =
        ref.read(tugasDinasListControllerProvider.notifier).isHrdOrSpv(spv);
    final spvAbsenManual =
        ref.read(absenManualListControllerProvider.notifier).isHrdOrSpv(spv);

    if (spvCuti ||
        spvDtPc ||
        spvIzin ||
        spvSakit ||
        spvTugasDinas ||
        spvAbsenManual) {
      return true;
    }

    return false;
  }
}
