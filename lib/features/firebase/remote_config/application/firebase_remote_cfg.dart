import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../constants/constants.dart';

part 'firebase_remote_cfg.freezed.dart';
part 'firebase_remote_cfg.g.dart';

@freezed
class FirebaseRemoteCfg with _$FirebaseRemoteCfg {
  factory FirebaseRemoteCfg({
    required String baseUrl,
    required String baseUrlHosting,
    required String minApp,
    required String iosUserMaintanance,
    required Map<String, String> ptMap,
  }) = _FirebaseRemoteConfig;

  factory FirebaseRemoteCfg.initial() => FirebaseRemoteCfg(
        ptMap: Constants.ptMap,
        minApp: Constants.minApp,
        baseUrl: Constants.baseUrl,
        baseUrlHosting: Constants.baseUrlHosting,
        iosUserMaintanance: Constants.iosUserMaintanance,
      );

  factory FirebaseRemoteCfg.fromJson(Map<String, dynamic> json) =>
      _$FirebaseRemoteCfgFromJson(json);
}
