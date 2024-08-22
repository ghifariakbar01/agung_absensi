import 'package:dartz/dartz.dart';

import '../../domain/failures.dart';
import '../../../infrastructures/exceptions.dart';
import 'cross_auth_server_remote_service.dart';

class CrossAuthServerRepository {
  CrossAuthServerRepository(this._remoteService);

  final CrossAuthServerRemoteService _remoteService;

  Future<Either<UserNotFound, Unit>> getSakitList({
    required String username,
    required String pass,
  }) async {
    try {
      final resp = await _remoteService.getSakitList(
        username: username,
        pass: pass,
      );

      return right(resp);
    } on NoConnectionException {
      return left(UserNotFound());
    } on RestApiExceptionWithMessage catch (e) {
      if (e.errorCode == 404) {
        return left(UserNotFound());
      } else {
        rethrow;
      }
    }
  }
}
