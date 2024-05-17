import 'dart:io';

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
      "base_url_hosting": Constants.baseUrlHosting,
      "min_app": Constants.minApp,
    });

    try {
      await remoteConfig.fetchAndActivate();
    } on FirebaseException catch (_) {
      return await _onOffline(remoteConfig);
    }

    final baseUrl = await remoteConfig.getString(Constants.keyBaseUrl);
    final baseUrlHosting =
        await remoteConfig.getString(Constants.keyBaseUrlHosting);
    final minApp = await remoteConfig.getString(
        Platform.isAndroid ? Constants.keyMinApp : Constants.keyMinAppiOS);

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

    final cfg = FirebaseRemoteCfg(
        baseUrl: baseUrl, baseUrlHosting: baseUrlHosting, minApp: minApp);

    await _saveCfg(cfg);

    await remoteConfig.ensureInitialized();

    return cfg;
  }

  Future<FirebaseRemoteCfg> _onOffline(
      FirebaseRemoteConfig remoteConfig) async {
    final repo = ref.read(firebaseRemoteConfigRepositoryProvider);

    if (await repo.hasStorage()) {
      final FirebaseRemoteCfg? cfg =
          await repo.getFirebaseRemoteConfigStorage();
      return cfg!;
    }

    final baseUrl = await remoteConfig.getString(Constants.keyBaseUrl);
    final baseUrlHosting =
        await remoteConfig.getString(Constants.keyBaseUrlHosting);
    final minApp = await remoteConfig.getString(
        Platform.isAndroid ? Constants.keyMinApp : Constants.keyMinAppiOS);

    return FirebaseRemoteCfg(
        baseUrl: baseUrl, baseUrlHosting: baseUrlHosting, minApp: minApp);
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
