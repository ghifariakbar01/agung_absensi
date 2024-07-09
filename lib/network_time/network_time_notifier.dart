import 'package:ntp/ntp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_time_notifier.g.dart';

@riverpod
class NetworkTimeNotifier extends _$NetworkTimeNotifier {
  @override
  FutureOr<DateTime> build() async {
    return _get();
  }

  Future<DateTime> _get() async {
    DateTime startDate = new DateTime.now().toLocal();
    int offset = await NTP.getNtpOffset(localTime: startDate);
    return startDate.add(new Duration(milliseconds: offset));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _get();
    });
  }
}
