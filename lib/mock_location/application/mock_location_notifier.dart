import 'package:geofence_service/geofence_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'mock_location_state.dart';

class MockLocationNotifier extends StateNotifier<MockLocationState> {
  MockLocationNotifier() : super(MockLocationState.initial());

  checkMockLocationState(Location location) {
    if (location.isMock) {
      state = const MockLocationState.mocked();
    } else {
      state = const MockLocationState.original();
    }
  }
}
