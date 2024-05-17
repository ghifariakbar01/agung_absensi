import '../../infrastructures/credentials_storage/credentials_storage.dart';

class UnlinkRepository {
  UnlinkRepository(this._credentialsStorage);

  final CredentialsStorage _credentialsStorage;

  saveUnlink() async {
    return _credentialsStorage.save('${DateTime.now()}');
  }

  Future<String?> getUnlink() async {
    return _credentialsStorage.read();
  }
}
