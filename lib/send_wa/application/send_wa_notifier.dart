import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';

import '../infrastructure/send_wa_remote_service.dart';
import '../infrastructure/send_wa_repository.dart';
import 'phone_num.dart';

part 'send_wa_notifier.g.dart';

const bool isTesting = true;

@Riverpod(keepAlive: true)
SendWaRemoteService sendWaRemoteService(SendWaRemoteServiceRef ref) {
  return SendWaRemoteService(
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
SendWaRepository sendWaRepository(SendWaRepositoryRef ref) {
  return SendWaRepository(
    ref.watch(sendWaRemoteServiceProvider),
  );
}

@riverpod
class SendWaNotifier extends _$SendWaNotifier {
  @override
  FutureOr<void> build() {}

  Future<Unit> sendWaDirect(
      {
      //
      required int phone,
      required int idUser,
      required int idDept,
      required String notifTitle,
      required String notifContent
      //
      }) async {
    if (isTesting) {
      return unit;
    }

    return ref.read(sendWaRepositoryProvider).sendWa(
        phone: phone,
        idUser: idUser,
        idDept: idDept,
        notifTitle: notifTitle,
        notifContent: notifContent);
  }

  Future<void> processAndSendWa(
      {required int idUser,
      required int idDept,
      required PhoneNum phoneNum,
      required String messageContent}) async {
    bool noTelp1Empty = false;
    bool noTelp2Empty = false;

    if (isTesting) {
      return;
    }

    if (phoneNum.noTelp1 != null) {
      if (phoneNum.noTelp1!.isEmpty) {
        noTelp1Empty = true;
      } else {
        await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
            phone: int.parse(phoneNum.noTelp1!),
            idUser: idUser,
            idDept: idDept,
            notifTitle: 'Notifikasi HRMS',
            notifContent: '$messageContent');
      }
    }

    if (phoneNum.noTelp2 != null) {
      if (phoneNum.noTelp2!.isEmpty) {
        noTelp2Empty = true;
      } else {
        await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
            phone: int.parse(phoneNum.noTelp2!),
            idUser: idUser,
            idDept: idDept,
            notifTitle: 'Notifikasi HRMS',
            notifContent: '$messageContent');
      }
    }

    if ((phoneNum.noTelp1 == null && phoneNum.noTelp2 == null) ||
        (noTelp1Empty == true && noTelp2Empty == true))
      throw AssertionError(
          'User yang dituju tidak memiliki nomor telfon. Silahkan hubungi HR untuk mengubah data ');
  }

  Future<PhoneNum> getPhoneById({required int idUser}) async {
    return ref.read(sendWaRepositoryProvider).getPhoneById(idUser: idUser);
  }
}
