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
    if (json == null) {
      return FirebaseRemoteCfg.initial();
    } else {
      try {
        final _resp = jsonDecode(json);
        return FirebaseRemoteCfg.fromJson(_resp as Map<String, dynamic>);
      } on FormatException catch (_) {
        await _credentialsStorage.clear();
        return FirebaseRemoteCfg.initial();
      }
    }
  }

  Future<void> saveFirebaseRemoteConfigStorage(FirebaseRemoteCfg cfg) async {
    final json = jsonEncode(cfg.toJson());
    return _credentialsStorage.save(json);
  }

  Future<void> clearFirebaseRemoteConfigStorage() async {
    return _credentialsStorage.clear();
  }
}
