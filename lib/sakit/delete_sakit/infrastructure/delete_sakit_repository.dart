import 'package:dartz/dartz.dart';

import 'delete_sakit_remote_service.dart';

class DeleteSakitRepository {
  DeleteSakitRepository(this._remoteService);

  final DeleteSakitRemoteService _remoteService;

  Future<Unit> deleteSakit({
    required int idSakit,
  }) {
    return _remoteService.deleteSakit(idSakit: idSakit);
  }
}
