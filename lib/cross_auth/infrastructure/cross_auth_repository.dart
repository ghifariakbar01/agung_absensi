import '../application/cross_auth_response.dart';
import 'cross_auth_remote_service.dart';

class CrossAuthRepository {
  CrossAuthRepository(this._remoteService);

  final CrossAuthRemoteService _remoteService;

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
