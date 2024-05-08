import 'dart:convert';

import '../../infrastructure/cache_storage/cross_auth_storage.dart';
import '../../user/application/user_model.dart';
import '../application/cross_auth_response.dart';
import 'cross_auth_remote_service.dart';

class CrossAuthRepository {
  CrossAuthRepository(
    this._storage,
    this._remoteService,
  );

  final CrossAuthStorage _storage;
  final CrossAuthRemoteService _remoteService;

  Future<void> save(UserModelWithPassword user) async {
    return _storage.save(jsonEncode(user.toJson()));
  }

  Future<void> clear() async {
    return _storage.clear();
  }

  Future<bool> hasStorage() async {
    return await _storage.read() != null;
  }

  Future<UserModelWithPassword> loadSavedCrossed() async {
    final raw = await _storage.read();
    return UserModelWithPassword.fromJson(jsonDecode(raw!));
  }

  //  'gs_12': [
  //    'PT Agung Citra Transformasi',
  //    'PT Agung Transina Raya',
  //    'PT Agung Lintas Raya'
  //  ],
  //  'gs_14': ['PT Agung Tama Raya'],
  //  'gs_21': ['PT Agung Jasa Logistik'],
  Future<CrossAuthResponse> crossToACT(
      {required String userId,
      required String password,
      required String server}) async {
    return _remoteService.crossToACT(
        userId: userId, password: password, server: server);
  }

  //  'gs_18': ['PT Agung Raya'],
  Future<CrossAuthResponse> crossToARV(
      {required String userId,
      required String password,
      required String server}) async {
    return _remoteService.crossToARV(
        userId: userId, password: password, server: server);
  }
}
