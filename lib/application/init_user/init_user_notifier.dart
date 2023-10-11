import 'dart:developer';

import 'package:face_net_authentication/application/imei_introduction/shared/imei_introduction_providers.dart';
import 'package:face_net_authentication/application/init_user/init_user_status.dart';
import 'package:face_net_authentication/shared/providers.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/// call [checkAndUpdateAuthStatus] make sure routeNotifier forced notifyListeners()
/// else
/// would not call
class InitUserNotifier extends StateNotifier<InitUserStatus> {
  InitUserNotifier(this.ref) : super(InitUserStatus.failure());

  final Ref ref;

  Future<void> letYouThrough() async {
    state = const InitUserStatus.success();
  }

  Future<void> hold() async {
    state = const InitUserStatus.init();
  }
}
