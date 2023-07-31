import 'package:face_net_authentication/application/tc/tc_notifier.dart';
import 'package:face_net_authentication/application/tc/tc_repository.dart';
import 'package:face_net_authentication/application/tc/tc_state.dart';
import 'package:face_net_authentication/infrastructure/storage/tc_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infrastructure/credentials_storage/credentials_storage.dart';
import '../../../shared/providers.dart';

final tcStorageProvider = Provider<CredentialsStorage>(
  (ref) => TCStorage(ref.watch(flutterSecureStorageProvider)),
);

final tcRepositoryProvider =
    Provider((ref) => TCRepository(ref.watch(tcStorageProvider)));

final tcNotifierProvider = StateNotifierProvider<TCNotifier, TCState>(
    (ref) => TCNotifier(ref.watch(tcRepositoryProvider)));
