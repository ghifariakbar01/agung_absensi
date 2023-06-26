import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../absen/absen_detail_state.dart';

final riwayatAbsenById = StateProvider<RiwayatAbsenDetailState>(
    ((ref) => RiwayatAbsenDetailState.initial()));
