import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'network_state.dart';

final networkStateNotifierProvider =
    StateNotifierProvider<NetworkStateNotifier, NetworkState>(
        (ref) => NetworkStateNotifier());

class NetworkStateNotifier extends StateNotifier<NetworkState> {
  get controller => StreamController<ConnectivityResult>();

  NetworkState lastResult = NetworkState.online();

  NetworkStateNotifier() : super(NetworkState.online()) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        if (state != NetworkState.offline()) state = NetworkState.offline();
      } else {
        if (state != NetworkState.online()) state = NetworkState.online();
      }
    });
  }
}
