// ignore_for_file: unused_result

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:face_net_authentication/cross_auth_server/cross_auth_server_notifier.dart';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../firebase/remote_config/helper/firebase_remote_config_initializer.dart';
import '../../shared/providers.dart';

import '../infrastructure/network_state_remote_service.dart';
import '../infrastructure/network_state_repository.dart';
import 'network_response.dart';
import 'network_state.dart';
part 'network_state_notifier.g.dart';

@Riverpod(keepAlive: true)
NetworkStateRemoteService networkStateRemoteService(
    NetworkStateRemoteServiceRef ref) {
  return NetworkStateRemoteService(
    ref.watch(dioProvider),
    ref.watch(dioRequestProvider),
    ref.watch(userNotifierProvider).user,
  );
}

@Riverpod(keepAlive: true)
NetworkStateRepository networkStateRepository(NetworkStateRepositoryRef ref) {
  return NetworkStateRepository(
    ref.watch(networkStateRemoteServiceProvider),
  );
}

@riverpod
class NetworkStateNotifier2 extends _$NetworkStateNotifier2 {
  @override
  FutureOr<NetworkState> build() async {
    return NetworkState.online();
  }
}

final firstTimeTimerProvider = StateProvider<bool>((ref) {
  return true;
});

/*
  CONNECTED TO :
    absenOfflineModeProvider,
    firstTimeTimerProvider,
    networkStateNotifier2Provider
*/

@riverpod
class NetworkCallback extends _$NetworkCallback {
  @override
  FutureOr<void> build() async {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        _setOfflineMode();
      } else {
        final firstTime = ref.read(firstTimeTimerProvider);

        if (firstTime) {
          await startFetch();

          ref.read(firstTimeTimerProvider.notifier).state = false;
        }

        await _fetchCurrentUrlEvery(
          Duration(minutes: 30),
          fetchUrl: startFetch,
        );
      }
    });
  }

  Future<void> startFetch() async {
    ref.read(networkStateNotifier2Provider.notifier).state =
        AsyncValue.loading();

    try {
      final _resp = await _fetchCurrentUrl();
      await _resp.maybeWhen(withData: () async {
        _setOnlineMode();
      }, orElse: () {
        _setOfflineMode();
      });
    } catch (_) {
      _setOfflineMode();
    }
  }

  void _setOfflineMode() {
    print(
        'PING -- _fetchCurrentUrl() getting Current Url State : NetworkState.offline() ');
    ref.read(networkStateNotifier2Provider.notifier).state =
        AsyncValue.data(NetworkState.offline());

    ref.read(firstTimeTimerProvider.notifier).state = true;
    ref.read(absenOfflineModeProvider.notifier).state = true;
  }

  Future<void> _setOnlineMode() async {
    print(
        'PING -- _fetchCurrentUrl() getting Current Url State : NetworkState.online() ');
    ref.read(networkStateNotifier2Provider.notifier).state =
        AsyncValue.data(NetworkState.online());
    ref.read(absenOfflineModeProvider.notifier).state = false;

    await FirebaseRemoteConfigInitializer.setupRemoteConfig(ref);
    await ref.refresh(crossAuthServerNotifierProvider);
  }

  Future<Timer> _fetchCurrentUrlEvery(Duration interval,
      {required Future<void> Function() fetchUrl}) async {
    return Timer.periodic(interval, (_) => fetchUrl());
  }

  Future<NetworkResponse> _fetchCurrentUrl() async {
    return ref.read(networkStateRepositoryProvider).fetchCurrentUrl();
  }
}
