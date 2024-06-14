// ignore_for_file: unused_result

import 'dart:io';

import 'package:face_net_authentication/ip/application/ip_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/constants.dart';

import '../../../infrastructures/cache_storage/firebase_remote_config_storage.dart';
import '../../../infrastructures/credentials_storage/credentials_storage.dart';
import '../../../shared/providers.dart';

import '../infrastructures/firebase_remote_config_repository.dart';
import 'firebase_remote_cfg.dart';

part 'firebase_remote_config_notifier.g.dart';

enum RemoteConfigFetchInterval { isProduction, isDevelopment }

final firebaseRemoteConfigStorageProvider = Provider<CredentialsStorage>(
  (ref) => FirebaseRemoteConfigStorage(ref.watch(flutterSecureStorageProvider)),
);

@Riverpod(keepAlive: true)
FirebaseRemoteConfigRepository firebaseRemoteConfigRepository(
    FirebaseRemoteConfigRepositoryRef ref) {
  return FirebaseRemoteConfigRepository(
      ref.watch(firebaseRemoteConfigStorageProvider));
}

@riverpod
class FirebaseRemoteConfigNotifier extends _$FirebaseRemoteConfigNotifier {
  @override
  FutureOr<FirebaseRemoteCfg> build() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Constants.defaultFetchTimeOut,
      minimumFetchInterval: Constants.prodFetchInterval,
    ));

    await remoteConfig.setDefaults(const {
      "base_url": Constants.baseUrl,
      "min_app": Constants.minApp,
      "base_url_hosting": Constants.baseUrlHosting,
      "gs_12": "http://agungcartrans.co.id:1232/services",
      "gs_14": "https://agungcartrans.co.id:2601/services",
      "gs_18": "https://www.agunglogisticsapp.co.id:2002/services",
      "gs_21": "https://www.agunglogisticsapp.co.id:3603/services",
    });

    try {
      await remoteConfig.fetchAndActivate();
    } on FirebaseException catch (_) {
      return await _onOffline(remoteConfig);
    }

    FirebaseRemoteCfg cfg = FirebaseRemoteCfg.initial();

    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();

      cfg = _returnCfg(remoteConfig);
      await _saveCfg(cfg);

      state = const AsyncLoading();

      state = await AsyncValue.guard(() async {
        await ref.refresh(ipNotifierProvider.future);
        return cfg;
      });
    });

    cfg = _returnCfg(remoteConfig);
    await remoteConfig.ensureInitialized();
    return cfg;
  }

  Map<String, String> getPtMap() {
    final remoteConfig = FirebaseRemoteConfig.instance;

    final Map<String, String> ptMap = {
      "gs_12": remoteConfig.getString('gs_12'),
      "gs_14": remoteConfig.getString('gs_14'),
      "gs_18": remoteConfig.getString('gs_18'),
      "gs_21": remoteConfig.getString('gs_21'),
    };

    return ptMap;
  }

  FirebaseRemoteCfg _returnCfg(FirebaseRemoteConfig remoteConfig) {
    final baseUrl = remoteConfig.getString(Constants.keyBaseUrl);
    final baseUrlHosting = remoteConfig.getString(Constants.keyBaseUrlHosting);
    final minApp = remoteConfig.getString(
        Platform.isAndroid ? Constants.keyMinApp : Constants.keyMinAppiOS);

    final Map<String, String> ptMap = {
      "gs_12": remoteConfig.getString('gs_12'),
      "gs_14": remoteConfig.getString('gs_14'),
      "gs_18": remoteConfig.getString('gs_18'),
      "gs_21": remoteConfig.getString('gs_21'),
    };

    debugPrint(
        '╔══════════════════════════════════════════════════════════════╗');
    debugPrint(
        '                   -- Firebase RemoteConfig --                 ');
    debugPrint(
        '                   -- Last Fetch Status : ${remoteConfig.lastFetchStatus} --             ');
    debugPrint(
        '                   -- Last Fetch Time : ${remoteConfig.lastFetchTime} --                 ');
    debugPrint(
        '╚══════════════════════════════════════════════════════════════╝');

    return FirebaseRemoteCfg(
      ptMap: ptMap,
      minApp: minApp,
      baseUrl: baseUrl,
      baseUrlHosting: baseUrlHosting,
    );
  }

  Future<FirebaseRemoteCfg> _onOffline(
      FirebaseRemoteConfig remoteConfig) async {
    final repo = ref.read(firebaseRemoteConfigRepositoryProvider);

    if (await repo.hasStorage()) {
      final FirebaseRemoteCfg? cfg =
          await repo.getFirebaseRemoteConfigStorage();
      return cfg!;
    }

    final baseUrl = remoteConfig.getString(Constants.keyBaseUrl);
    final baseUrlHosting = remoteConfig.getString(Constants.keyBaseUrlHosting);
    final minApp = remoteConfig.getString(
        Platform.isAndroid ? Constants.keyMinApp : Constants.keyMinAppiOS);

    final Map<String, String> ptMap = {
      "gs_12": remoteConfig.getString('gs_12'),
      "gs_14": remoteConfig.getString('gs_14'),
      "gs_18": remoteConfig.getString('gs_18'),
      "gs_21": remoteConfig.getString('gs_21'),
    };

    return FirebaseRemoteCfg(
      ptMap: ptMap,
      baseUrl: baseUrl,
      minApp: minApp,
      baseUrlHosting: baseUrlHosting,
    );
  }

  Future<void> _saveCfg(FirebaseRemoteCfg cfg) async {
    final repo = ref.read(firebaseRemoteConfigRepositoryProvider);

    return repo.saveFirebaseRemoteConfigStorage(cfg);
  }

  Future<void> clearSavedCfg() async {
    final repo = ref.read(firebaseRemoteConfigRepositoryProvider);

    return repo.clearFirebaseRemoteConfigStorage();
  }
}
