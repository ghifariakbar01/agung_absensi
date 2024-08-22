import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/providers.dart';
import 'is_hrd_or_spv_izin_list.dart';

part 'is_hrd_or_spv_izin_list_notifier.g.dart';

@riverpod
class IsHrdOrSPVIzinListNotifier extends _$IsHrdOrSPVIzinListNotifier {
  @override
  FutureOr<IsHrdOrSPVIzinList> build() async {
    final hrd = ref.read(userNotifierProvider).user.fin;

    final isHrdOrSpv = _isHrdOrSpv(hrd);
    return isHrdOrSpv
        ? IsHrdOrSPVIzinList.isHrdOrSpv()
        : IsHrdOrSPVIzinList.isRegularStaff();
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
      _isHrdOrSpv = access!.contains('5,');
    } else {
      _isHrdOrSpv = access!.contains('5104,');
    }

    return _isHrdOrSpv;
  }

  bool _isAct() {
    final server = ref.read(userNotifierProvider).user.ptServer;
    return server != 'gs_18';
  }
}
