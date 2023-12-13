import 'package:face_net_authentication/application/init_user/init_user_status.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

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
