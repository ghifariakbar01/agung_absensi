import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../infrastructure/create_ganti_hari_remote_service.dart';
import '../infrastructure/create_ganti_hari_repository.dart';
import 'absen_ganti_hari.dart';

part 'create_ganti_hari_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateGantiHariRemoteService createGantiHariRemoteService(
    CreateGantiHariRemoteServiceRef ref) {
  return CreateGantiHariRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CreateGantiHariRepository createGantiHariRepository(
    CreateGantiHariRepositoryRef ref) {
  return CreateGantiHariRepository(
    ref.watch(createGantiHariRemoteServiceProvider),
  );
}

@riverpod
class AbsenGantiHariNotifier extends _$AbsenGantiHariNotifier {
  @override
  FutureOr<List<AbsenGantiHari>> build() async {
    return ref.read(createGantiHariRepositoryProvider).getAbsenGantiHari();
  }
}
