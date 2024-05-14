import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import 'is_hrd_or_spv_dt_pc_list.dart';

part 'is_hrd_or_spv_dt_pc_list_notifier.g.dart';

@riverpod
class IsHrdOrSPVDtPcListNotifier extends _$IsHrdOrSPVDtPcListNotifier {
  @override
  FutureOr<IsHrdOrSPVIDtPcList> build() async {
    final hrd = ref.read(userNotifierProvider).user.fin;

    final isHrdOrSpv = _isHrdOrSpv(hrd);
    return isHrdOrSpv
        ? IsHrdOrSPVIDtPcList.isHrdOrSpv()
        : IsHrdOrSPVIDtPcList.isRegularStaff();
  }

  bool _isHrdOrSpv(String? access) {
    bool _isHrdOrSpv = true;

    final fullAkses = ref.read(userNotifierProvider).user.fullAkses;

    if (access == null) {
      _isHrdOrSpv = false;
    }

    if (fullAkses! == false) {
      _isHrdOrSpv = false;
    }

    if (_isAct()) {
      _isHrdOrSpv = access!.contains('18,');
    } else {
      _isHrdOrSpv = access!.contains('5103,');
    }

    return _isHrdOrSpv;
  }

  bool _isAct() {
    final server = ref.read(userNotifierProvider).user.ptServer;
    return server != 'gs_18';
  }
}
