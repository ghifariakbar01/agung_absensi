import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../infrastructures/cache_storage/tc_storage.dart';
import '../../../shared/providers.dart';
import '../tc_notifier.dart';
import '../tc_repository.dart';
import '../tc_state.dart';

part 'tc_providers.g.dart';

@Riverpod(keepAlive: true)
TCStorage tcStorage(TcStorageRef ref) {
  return TCStorage(
    ref.watch(flutterSecureStorageProvider),
  );
}

@Riverpod(keepAlive: true)
TCRepository tcRepository(TcRepositoryRef ref) {
  return TCRepository(
    ref.watch(tcStorageProvider),
  );
}

final tcNotifierProvider = StateNotifierProvider<TCNotifier, TCState>(
    (ref) => TCNotifier(ref.watch(tcRepositoryProvider)));
