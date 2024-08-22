import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/providers.dart';
import 'is_hrd_or_spv_ganti_hari_list.dart';

part 'is_hrd_or_spv_ganti_hari_list_notifier.g.dart';

@riverpod
class IsHrdOrSPVGantiHariListNotifier
    extends _$IsHrdOrSPVGantiHariListNotifier {
  @override
  FutureOr<IsHrdOrSPVIGantiHariList> build() async {
    final hrd = ref.read(userNotifierProvider).user.fin;

    final isHrdOrSpv = _isHrdOrSpv(hrd);
    return isHrdOrSpv
        ? IsHrdOrSPVIGantiHariList.isHrdOrSpv()
        : IsHrdOrSPVIGantiHariList.isRegularStaff();
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
      _isHrdOrSpv = access!.contains('17,');
    } else {
      _isHrdOrSpv = access!.contains('5106,');
    }

    return _isHrdOrSpv;
  }

  bool _isAct() {
    final server = ref.read(userNotifierProvider).user.ptServer;
    return server != 'gs_18';
  }
}
