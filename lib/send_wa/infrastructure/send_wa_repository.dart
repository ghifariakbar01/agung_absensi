import 'package:dartz/dartz.dart';

import '../application/phone_num.dart';
import 'send_wa_remote_service.dart';

class SendWaRepository {
  SendWaRepository(this._remoteService);

  final SendWaRemoteService _remoteService;

  Future<Unit> sendWa(
      {
      //
      required int phone,
      required int idUser,
      required int idDept,
      required String notifTitle,
      required String notifContent
      //
      }) async {
    return _remoteService.sendWa(
        phone: phone,
        idUser: idUser,
        idDept: idDept,
        notifTitle: notifTitle,
        notifContent: notifContent);
  }

  Future<PhoneNum> getPhoneById({
    required int idUser,
  }) async {
    return _remoteService.getPhoneById(
      idUser: idUser,
    );
  }
}
