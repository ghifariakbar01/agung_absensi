import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../izin_list/application/izin_list_notifier.dart';
import '../../izin_list/application/jenis_izin.dart';

part 'jenis_izin_notifier.g.dart';

@riverpod
class JenisIzinNotifier extends _$JenisIzinNotifier {
  @override
  FutureOr<List<JenisIzin>> build() {
    return ref.read(izinListRepositoryProvider).getJenisIzin();
  }
}
