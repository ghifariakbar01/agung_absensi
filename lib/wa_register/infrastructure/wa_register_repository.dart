import '../../infrastructure/credentials_storage/credentials_storage.dart';

class WaRegisterRepository {
  WaRegisterRepository(this._storage);

  final CredentialsStorage _storage;

  Future<String?> getWaRegister() async {
    final response = await _storage.read();

    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  Future<void> save(String phone) {
    return _storage.save(phone);
  }

  Future<void> clear() {
    return _storage.clear();
  }
}
