import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ios_user_maintanance_notifier.g.dart';

@riverpod
class IosUserMaintanance extends _$IosUserMaintanance {
  @override
  FutureOr<String> build() async {
    return '';
  }

  setIosUserMaintanance(String val) {
    state = AsyncData(val);
  }
}
