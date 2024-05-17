import 'dart:convert';

import '../../../infrastructures/credentials_storage/credentials_storage.dart';
import '../application/firebase_remote_cfg.dart';

class FirebaseRemoteConfigRepository {
  final CredentialsStorage _credentialsStorage;

  FirebaseRemoteConfigRepository(this._credentialsStorage);

  Future<bool> hasStorage() async => await _credentialsStorage
      .read()
      .then((value) => value != null && value.isNotEmpty);

  Future<FirebaseRemoteCfg?> getFirebaseRemoteConfigStorage() async {
    final json = await _credentialsStorage.read();
    return FirebaseRemoteCfg.fromJson(json as Map<String, dynamic>);
  }

  Future<void> saveFirebaseRemoteConfigStorage(FirebaseRemoteCfg cfg) async {
    final json = jsonEncode(cfg.toJson());
    return _credentialsStorage.save(json);
  }

  Future<void> clearFirebaseRemoteConfigStorage() =>
      _credentialsStorage.clear();
}
