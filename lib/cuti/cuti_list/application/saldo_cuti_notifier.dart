import 'package:face_net_authentication/shared/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../sakit/create_sakit/application/create_sakit_cuti.dart';
import '../../../sakit/create_sakit/application/create_sakit_notifier.dart';

part 'saldo_cuti_notifier.g.dart';

@riverpod
class SaldoCutiNotifier extends _$SaldoCutiNotifier {
  @override
  FutureOr<CreateSakitCuti> build() async {
    final user = ref.read(userNotifierProvider).user;

    if (user.idUser == null) {
      throw AssertionError('ID User Null');
    }

    if (user.IdKary == null) {
      throw AssertionError('ID Karyawan Null');
    }

    //
    return await ref.read(createSakitRepositoryProvider).getSaldoMasterCuti(
          idUser: user.idUser!,
        );
  }
}
