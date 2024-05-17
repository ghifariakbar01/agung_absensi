import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../ip/application/ip_notifier.dart';

class FirebaseRemoteConfigInitializer {
  static Future<void> setupRemoteConfig(Ref ref) async {
    return ref.refresh(ipNotifierProvider.future);
  }
}
