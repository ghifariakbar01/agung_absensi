import 'package:dio/dio.dart';
import 'package:face_net_authentication/cross_auth/application/cross_auth_response.dart';
import 'package:face_net_authentication/cross_auth/infrastructures/cross_auth_remote_service.dart';
import 'package:face_net_authentication/cross_auth/infrastructures/cross_auth_repository.dart';
import 'package:face_net_authentication/user/application/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../infrastructures/cache_storage/cross_auth_storage.dart';
import '../../shared/providers.dart';
import 'is_user_crossed.dart';

part 'cross_auth_notifier.g.dart';

@Riverpod(keepAlive: true)
CrossAuthStorage crossAuthStorage(CrossAuthStorageRef ref) {
  return CrossAuthStorage(
    ref.watch(flutterSecureStorageProvider),
  );
}

@Riverpod(keepAlive: true)
CrossAuthRemoteService crossAuthRemoteService(CrossAuthRemoteServiceRef ref) {
  return CrossAuthRemoteService(
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CrossAuthRepository crossAuthRepository(CrossAuthRepositoryRef ref) {
  return CrossAuthRepository(
    ref.watch(crossAuthStorageProvider),
    ref.watch(crossAuthRemoteServiceProvider),
  );
}

enum PT { ACT, ARV }

@riverpod
class IsUserCrossed extends _$IsUserCrossed {
  @override
  FutureOr<IsUserCrossedState> build() async {
    return determine();
  }

  Future<bool> _hasStorage() async {
    final repo = ref.read(crossAuthRepositoryProvider);
    return await repo.hasStorage();
  }

  Future<IsUserCrossedState> determine() async {
    final repo = ref.read(crossAuthRepositoryProvider);

    if (await _hasStorage() == false) {
      return IsUserCrossedState.notCrossed();
    } else {
      final UserModelWithPassword _userSaved = await repo.loadSavedCrossed();
      final UserModelWithPassword _currentUser =
          ref.read(userNotifierProvider).user;

      if (_hasDifferentImei(_userSaved, _currentUser)) {
        await _replaceCrossed();
        await determine();
      }

      if (_userSaved == _currentUser) {
        return IsUserCrossedState.notCrossed();
      } else {
        return IsUserCrossedState.crossed();
      }
    }
  }

  _hasDifferentImei(
      UserModelWithPassword _userSaved, UserModelWithPassword _currentUser) {
    if (_userSaved != _currentUser) {
      if (_userSaved.ptServer == _currentUser.ptServer) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> _replaceCrossed() async {
    final user = ref.read(userNotifierProvider).user;
    await ref.read(crossAuthRepositoryProvider).save(user);
  }
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

  final Map<String, List<String>> _mapPT = {
    'gs_12': ['ACT', 'Transina', 'ALR'],
    'gs_14': ['Tama Raya'],
    'gs_18': ['ARV'],
    'gs_21': ['AJL'],
  };

  String? _determineServer(List<String> server) {
    String serv = '';

    _equal(List<String> serv, List<String> serv2) {
      return serv.first == serv2.first;
    }

    _mapPT.entries.forEach((element) {
      final String key = element.key;

      if (_equal(server, element.value)) {
        serv = key;
      }
    });

    if (serv.isNotEmpty) {
      return serv;
    }

    return null;
  }

  final _key = 'first_time_cross';

  Future<bool> _firstTimeCross() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) == null;
  }

  Future<bool> _saveFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_key, '${DateTime.now()}');
  }

  Future<void> _saveCross() async {
    final user = ref.read(userNotifierProvider).user;
    await ref.read(crossAuthRepositoryProvider).save(user);
  }

  Future<void> _firstTime() async {
    if (await _firstTimeCross()) {
      await _saveCross();
      await _saveFirstTime();
    }
  }

  Future<void> uncross({
    required String userId,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final _crossRepo = ref.read(crossAuthRepositoryProvider);
      final _savedCrossUser = await _crossRepo.loadSavedCrossed();

      final String? serv = _savedCrossUser.ptServer;

      if (serv == null) {
        return;
      }

      await _resetCutiDioProvider(serv);

      if (serv == 'gs_18') {
        await _crossToARV(server: 'gs_18', userId: userId, password: password);
        return;
      } else {
        await _crossToACT(server: serv, userId: userId, password: password);
        return;
      }
    });
  }

  String _determineBaseUrl(String serv) {
    return Constants.ptMap.entries
        .firstWhere(
          (element) => element.key == serv,
          orElse: () => Constants.ptMap.entries.first,
        )
        .value;
  }

  _resetCutiDioProvider(String serv) {
    return ref.read(dioProviderCuti)
      ..options = BaseOptions(
        connectTimeout: Duration(seconds: 20),
        receiveTimeout: Duration(seconds: 20),
        validateStatus: (status) {
          return true;
        },
        baseUrl: _determineBaseUrl(serv),
      )
      ..interceptors.add(ref.read(authInterceptorTwoProvider));
  }

  Future<void> cross({
    required String userId,
    required String password,
    required List<String> pt,
  }) async {
    await _firstTime();

    final String? serv = _determineServer(pt);

    if (serv == null) {
      return;
    }

    await _resetCutiDioProvider(serv);

    if (serv == 'gs_18') {
      await _crossToARV(server: 'gs_18', userId: userId, password: password);
    } else {
      await _crossToACT(server: serv, userId: userId, password: password);
    }
  }

  Future<void> _crossToACT({
    required String server,
    required String userId,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final _response = await ref.read(crossAuthRepositoryProvider).crossToACT(
            server: server,
            userId: userId,
            password: password,
          );

      await _response.when(
        withUser: (user) async {
          await _saveUser(user);
          await ref
              .read(authNotifierProvider.notifier)
              .checkAndUpdateAuthStatus();

          await ref
              .read(userNotifierProvider.notifier)
              .onUserParsedRaw(ref: ref, user: user);
        },
        failure: (errorCode, message) {
          throw CrossAuthResponse.failure(
              errorCode: errorCode, message: message);
        },
      );

      state = AsyncData<void>('Sukses Cross ACT');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  //  'gs_18': ['PT Agung Raya'],
  Future<void> _crossToARV({
    required String server,
    required String userId,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final _response = await ref.read(crossAuthRepositoryProvider).crossToARV(
            server: server,
            userId: userId,
            password: password,
          );

      await _response.when(
        withUser: (user) async {
          await _saveUser(user);
          await ref
              .read(authNotifierProvider.notifier)
              .checkAndUpdateAuthStatus();

          await ref
              .read(userNotifierProvider.notifier)
              .onUserParsedRaw(ref: ref, user: user);
        },
        failure: (errorCode, message) {
          throw CrossAuthResponse.failure(
              errorCode: errorCode, message: message);
        },
      );

      state = AsyncData<void>('Sukses Cross ARV');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> _saveUser(UserModelWithPassword user) async {
    final _authRepository = ref.read(authRepositoryProvider);
    await _authRepository.saveUser(user);
  }
}
