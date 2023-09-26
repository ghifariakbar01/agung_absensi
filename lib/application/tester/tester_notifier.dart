import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import 'tester_state.dart';

class TesterhNotifier extends StateNotifier<TesterState> {
  TesterhNotifier(
    this._ref,
  ) : super(TesterState.initial());

  final Ref _ref;

  Future<void> checkAndUpdateTesterState() async {
    final isTester =
        await _ref.read(userNotifierProvider.notifier).getIsTester();

    if (isTester) {
      state = const TesterState.tester();
    } else {
      state = const TesterState.forcedRegularUser();
    }
  }

  forceChangeToRegular() => state = const TesterState.forcedRegularUser();

  forceChangeToTester() => state = const TesterState.tester();
}
