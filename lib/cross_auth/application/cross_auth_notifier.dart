import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/cross_auth/application/cross_auth_response.dart';
import 'package:face_net_authentication/cross_auth/infrastructure/cross_auth_remote_service.dart';
import 'package:face_net_authentication/cross_auth/infrastructure/cross_auth_repository.dart';
import 'package:face_net_authentication/user/application/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/providers.dart';

part 'cross_auth_notifier.g.dart';

@Riverpod(keepAlive: true)
CrossAuthRemoteService crossAuthRemoteService(CrossAuthRemoteServiceRef ref) {
  return CrossAuthRemoteService(
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CrossAuthRepository crossAuthRepository(CrossAuthRepositoryRef ref) {
  return CrossAuthRepository(
    ref.watch(crossAuthRemoteServiceProvider),
  );
}

@riverpod
class CrossAuthNotifier extends _$CrossAuthNotifier {
  @override
  FutureOr<void> build() async {}

  //  'gs_12': [
  //    'PT Agung Citra Transformasi',
  //    'PT Agung Transina Raya',
  //    'PT Agung Lintas Raya'
  //  ],
  //  'gs_14': ['PT Agung Tama Raya'],
  //  'gs_21': ['PT Agung Jasa Logistik'],
  Future<void> crossToACT({
    required String server,
    required String userId,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard<Unit>(() async {
      final _response = await ref.read(crossAuthRepositoryProvider).crossToACT(
            server: server,
            userId: userId,
            password: password,
          );

      return _response.when(
        withUser: (user) async {
          await _saveUser(user);
          await ref
              .read(authNotifierProvider.notifier)
              .checkAndUpdateAuthStatus();

          await ref
              .read(userNotifierProvider.notifier)
              .onUserParsedRaw(ref: ref, user: user);

          return unit;
        },
        failure: (errorCode, message) {
          throw CrossAuthResponse.failure(
              errorCode: errorCode, message: message);
        },
      );
    });
  }

  //  'gs_18': ['PT Agung Raya'],
  Future<void> crossToARV({
    required String server,
    required String userId,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard<Unit>(() async {
      final _response = await ref.read(crossAuthRepositoryProvider).crossToARV(
            server: server,
            userId: userId,
            password: password,
          );

      return _response.when(
        withUser: (user) async {
          await _saveUser(user);
          await ref
              .read(authNotifierProvider.notifier)
              .checkAndUpdateAuthStatus();

          await ref
              .read(userNotifierProvider.notifier)
              .onUserParsedRaw(ref: ref, user: user);

          return unit;
        },
        failure: (errorCode, message) {
          throw CrossAuthResponse.failure(
              errorCode: errorCode, message: message);
        },
      );
    });
  }

  Future<void> _saveUser(UserModelWithPassword user) async {
    final _authRepository = ref.read(authRepositoryProvider);
    await _authRepository.saveUser(user);
  }
}
