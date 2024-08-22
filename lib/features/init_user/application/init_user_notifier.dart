import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'init_user_status.dart';

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
