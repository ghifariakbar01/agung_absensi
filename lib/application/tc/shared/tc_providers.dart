import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infrastructure/cache_storage/tc_storage.dart';
import '../../../infrastructure/credentials_storage/credentials_storage.dart';
import '../../../shared/providers.dart';
import '../tc_notifier.dart';
import '../tc_repository.dart';
import '../tc_state.dart';

final tcStorageProvider = Provider<CredentialsStorage>(
  (ref) => TCStorage(ref.watch(flutterSecureStorageProvider)),
);

final tcRepositoryProvider =
    Provider((ref) => TCRepository(ref.watch(tcStorageProvider)));

final tcNotifierProvider = StateNotifierProvider<TCNotifier, TCState>(
    (ref) => TCNotifier(ref.watch(tcRepositoryProvider)));
