import 'package:face_net_authentication/domain/value_objects_copy.dart';
import 'package:face_net_authentication/shared/future_providers.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_helper_notifier.g.dart';

// for updating user data without login
@riverpod
class UserHelperNotifier extends _$UserHelperNotifier {
  @override
  FutureOr<void> build() async {
    final repo = ref.read(authRepositoryProvider);
    final user = ref.read(userNotifierProvider).user;

    final userId = UserId(user.nama ?? '');
    final server = PTName(user.ptServer ?? '');
    final password = Password(user.password ?? '');

    if (user.payroll == null) {
      await repo.saveUserPayrollOnCreateFormSakit(
          server: server, userId: userId, password: password);
      // ignore: unused_result
      ref.refresh(getUserFutureProvider);
      ref.notifyListeners();
    }
  }
}
