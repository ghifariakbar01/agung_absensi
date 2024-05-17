import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_remote_cfg.freezed.dart';
part 'firebase_remote_cfg.g.dart';

@freezed
class FirebaseRemoteCfg with _$FirebaseRemoteCfg {
  factory FirebaseRemoteCfg({
    required String baseUrl,
    required String baseUrlHosting,
    required String minApp,
  }) = _FirebaseRemoteConfig;

  factory FirebaseRemoteCfg.initial() =>
      FirebaseRemoteCfg(baseUrl: '', baseUrlHosting: '', minApp: '');

  factory FirebaseRemoteCfg.fromJson(Map<String, dynamic> json) =>
      _$FirebaseRemoteCfgFromJson(json);
}
