import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_remote_cfg.freezed.dart';
part 'firebase_remote_cfg.g.dart';

@freezed
class FirebaseRemoteCfg with _$FirebaseRemoteCfg {
  factory FirebaseRemoteCfg({
    required String baseUrl,
    required String baseUrlHosting,
    required String minApp,
    required Map<String, String> ptMap,
  }) = _FirebaseRemoteConfig;

  factory FirebaseRemoteCfg.initial() => FirebaseRemoteCfg(
        baseUrl: '',
        baseUrlHosting: '',
        minApp: '',
        ptMap: {},
      );

  factory FirebaseRemoteCfg.fromJson(Map<String, dynamic> json) =>
      _$FirebaseRemoteCfgFromJson(json);
}
