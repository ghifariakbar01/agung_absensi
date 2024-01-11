import 'package:face_net_authentication/shared/future_providers.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/value_objects_copy.dart';

part 'payroll_helper_notifier.g.dart';

@riverpod
class PayrollHelperNotifier extends _$PayrollHelperNotifier {
  @override
  FutureOr<void> build() async {
    final repo = ref.read(authRepositoryProvider);
    final user = ref.read(userNotifierProvider).user;

    final server = PTName(user.ptServer);
    final userId = UserId(user.nama ?? '');
    final password = Password(user.password ?? '');

    if (user.payroll == null) {
      await repo.saveUserPayrollOnCreateFormSakit(
          server: server, userId: userId, password: password);
      ref.refresh(getUserFutureProvider);
      ref.notifyListeners();
    }
  }
}
