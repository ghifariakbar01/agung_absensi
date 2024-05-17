import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../infrastructures/delete_sakit_remote_service.dart';
import '../infrastructures/delete_sakit_repository.dart';

part 'delete_sakit_notifier.g.dart';

@Riverpod(keepAlive: true)
DeleteSakitRemoteService deleteSakitRemoteService(
    DeleteSakitRemoteServiceRef ref) {
  return DeleteSakitRemoteService(
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
DeleteSakitRepository deleteSakitRepository(DeleteSakitRepositoryRef ref) {
  return DeleteSakitRepository(
    ref.watch(deleteSakitRemoteServiceProvider),
  );
}

@riverpod
class DeleteSakitNotifier extends _$DeleteSakitNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> deleteSakit({required int idSakit}) async {
    state = const AsyncLoading();

    final repo = ref.read(deleteSakitRepositoryProvider);

    state = await AsyncValue.guard(() => repo.deleteSakit(idSakit: idSakit));
  }
}
